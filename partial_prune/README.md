# partial_prune

This is similar to `docker prune`, but the scope is limited to images and containers.

The primary motivation for creating this script was, I wanted to get rid of a huge number of unused docker containers and images with keeping a few of them.

## Usage

1. Specify the containers and images you want to keep by editing the `containers_to_keep` and `images_to_keep` lists, respectively.
2. Run `ruby prune.rb`

As a result, it will remove all containers and images that aren't in the lists specified above.
