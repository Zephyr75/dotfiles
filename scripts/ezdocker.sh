#!/bin/bash

# define style
main="#00a600"
info="#acaf15"

clear

# ask user pseudo
username=$(gum input --placeholder "Enter Docker username")

library_url="https://hub.docker.com/v2/repositories/library/"
user_url="https://hub.docker.com/v2/repositories/${username}"
images=()

# get all docker hub images
i=0
while true; do
    response=$(curl -s "$library_url")
    page_images=($(echo "$response" | jq -r '.results[].name'))

    # add image names to the array
    for image in "${page_images[@]}"; do
        images+=("dockerhub/$image")
    done

    # check if there is a next page
    next_url=$(echo "$response" | jq -r '.next')
    if [ "$next_url" = "null" ]; then
        break
    fi

    # update the base URL for the next page
    library_url="$next_url"

    dots="$(for ((j=0; j < i % 4; j++)); do echo -n "."; done)"
    echo -ne "$(gum style --foreground "$main" "Getting official images$dots")      \r"
    i=$((i + 1))
done


# get all user images
i=0
while true; do
    response=$(curl -s "$user_url")
    page_images=($(echo "$response" | jq -r '.results[].name'))

    # add image names to the array
    for image in "${page_images[@]}"; do
        images+=("$username/$image")
    done

    # check if there is a next page
    next_url=$(echo "$response" | jq -r '.next')
    if [ "$next_url" = "null" ]; then
        break
    fi

    # update the base URL for the next page
    user_url="$next_url"

    dots="$(for ((j=0; j < i % 4; j++)); do echo -n "."; done)"
    echo -ne "$(gum style --foreground "$main" "Getting user images$dots")      \r"
    i=$((i + 1))
done

clear

tags_url=""

selected_image=$(echo "${images[@]}" | tr ' ' '\n' | gum filter)
# if selected image starts with dockerhub, remove everything before the first slash
if [[ $selected_image == *"dockerhub"* ]]
then
  selected_image=${selected_image#*/}
  tags_url="https://hub.docker.com/v2/repositories/library/$selected_image/tags"
else
  tags_url="https://hub.docker.com/v2/repositories/$selected_image/tags"
fi

# get all tags for the selected image
i=0
tags=()
while true; do
    response=$(curl -s "$tags_url")
    page_tags=($(echo "$response" | jq -r '.results[].name'))

    # add tag names to the array
    for tag in "${page_tags[@]}"; do
        tags+=("$tag")
    done

    # check if there is a next page
    next_url=$(echo "$response" | jq -r '.next')
    if [ "$next_url" = "null" ]; then
        break
    fi

    # update the base URL for the next page
    tags_url="$next_url"

    dots="$(for ((j=0; j < i % 4; j++)); do echo -n "."; done)"
    echo -ne "$(gum style --foreground "$main" "Getting tags$dots")      \r"
    i=$((i + 1))
done

# get the selected tag
selected_tag=$(echo "${tags[@]}" | tr ' ' '\n' | gum filter)

# print the selected image
echo "$(gum style --foreground "$main" "Image:")"
echo "$selected_image:$selected_tag"

# get run options
interactive="interactive"
volume="bind-current-directory"
delete="delete-when-stopped"

options=()
options+=("$interactive")
options+=("$volume")
options+=("$delete")

selected_options=($(echo "${options[@]}" | tr ' ' '\n' | gum choose --no-limit))

string_options=""

# print options
echo "$(gum style --foreground "$main" "Options:")"
for option in "${selected_options[@]}"; do
  echo "- $option"
  string_options+="$option "
done

# get container name
name=$(gum input --placeholder "Enter container name")

# print the selected name
echo "$(gum style --foreground "$main" "Name:")"
echo "$name"

# build docker command
command="sudo docker run --workdir /home "
if [[ $string_options == *"$interactive"* ]]; then
  command+="-it "
fi
if [[ $string_options == *"$volume"* ]]; then
  command+="-v $(pwd):/home "
fi
if [[ $string_options == *"$delete"* ]]; then
  command+="--rm "
fi
command+="--name $name "
command+="$selected_image:$selected_tag"

# confirm command
gum confirm "Confirm?" && $command || echo "$(gum style --foreground "$main" "Abort mission!")"
