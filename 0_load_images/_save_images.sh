#!/bin/bash -x

. ./image_list.env

for ((i=1;i<$NUM_IMAGES;i++)) do
  iname=${IMAGE_LIST[$i]}
  fname=${FILE_LIST[$i]}
		# Skip if image not found
  irepo=$(echo $iname | cut -d ":" -f1)
  itag=$(echo $iname | cut -d ":" -f2)
  if [[ "$(docker images | grep $irepo | grep $itag)" == "" ]]; then
    echo "Image $iname not found, skipping..."
    continue
  fi
		# Skip if image tarfile already exists
  if [ -f ./$fname ]; then
    echo "File $fname exists, skipping..."
    continue
  fi

  echo "Saving image $iname to file $fname..."
  docker save -o $fname $iname
done
