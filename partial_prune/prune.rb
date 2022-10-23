#!/usr/bin/ruby

def containers_to_keep
    ["mailhog", "python", "redis1"]
end

def images_to_keep
    ["mailhog/mailhog", "redis"]
end

def get_id_name_hashes(cmd_output, entry_type)
    lines = cmd_output.split("\n")
    hashes = []

    lines.each do |line|
        fields = line.split(/[\s]+/)

        id_idx = -1
        name_idx = -1
        items_to_keep = []

        if entry_type == :container
            id_idx = 0
            name_idx = -1
            items_to_keep = containers_to_keep
        elsif entry_type == :image
            id_idx = 2
            name_idx = 0
            items_to_keep = images_to_keep
        end

        next if ["CONTAINER", "REPOSITORY"].include? fields[0] || (id_idx == -1 && name_idx == -1)

        unless items_to_keep.include? fields[name_idx]
            hashes.push [fields[id_idx], fields[name_idx]]
        end
    end

    hashes
end

def run_cmd_on_list(list, cmd)
    list.each do |item|
        puts `#{cmd} #{item[0]}`
    end
end

def stop_containers(list)
    run_cmd_on_list(list, "docker container stop")
end

def delete_containers(list)
    run_cmd_on_list(list, "docker container rm")
end

def delete_images(list)
    run_cmd_on_list(list, "docker image rm")
end

currently_running_containers = get_id_name_hashes(`docker container ls`, :container)
all_containers = get_id_name_hashes(`docker container ls -a`, :container)
all_images = get_id_name_hashes(`docker image ls`, :image)

stop_containers(currently_running_containers)
delete_containers(all_containers)
delete_images(all_images)
