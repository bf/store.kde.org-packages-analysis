#!/bin/bash

set -e

dir=/home/beni/Downloads/kde

# echo "ID: $1";

XML=$(curl -S --no-progress-meter https://api.kde-look.org/ocs/v1/content/data/$1 | tr '\n' ' ');

if (grep -qi "xdg_type" <<< "$XML"); then
  (
      echo $XML | \
      tee $dir/api/$1.xml | \
    	xq -e '.ocs.data.content.downloadlink1' | \
      replace ' ' '%20' | \
	    xargs -I {} curl --globoff -S --no-progress-meter --create-dirs -O  -L --output-dir "$dir/raw/$1/"  "{}"
  ) && \
  (ls -lhR "$dir/raw/$1" > $dir/files/$1.txt) && \
  (echo -n $1 > last_successful_id) && \
  find "$dir/raw/$1/" -type f -a \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.bmp" -o -iname "*.svg" -o -iname "*.svgz" -o -iname "*.png" -o -iname "*.bmp" -o -iname "*.gif" -o -iname "*.webp" -o -iname "*.avi" -o -iname "*.mp3" -o -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.colors" -o -iname "*.xml" -o -iname "*.xpm" -o -iname "*.icon" -o -iname "*.colorscheme" -o -iname "*.pdf" -o -iname "*.css" -o -iname "*.scss" -o -iname "*.html" \) -delete && \
  (
    find $dir/raw/$1 -type f -print | while read f; do
      mkdir -p "$dir/extracted/$1/";
      if (bsdtar --totals -C "$dir/extracted/$1" -xf "$f" 2>/dev/null); then
        # echo "$1 $f extracted";
        (
          cd "$dir/extracted/$1/" && \
          find . -type f \( -iname "*.gz" -o -iname "*.zip" -o -iname "*.bz" -o -iname "*.tar" -o -iname "*.rar" -o -iname "*.bz2" -o -iname "*.7z" \) -exec bsdtar --totals -C . -xf {} \;
        )
      else
        # echo "$1 $f bsdtar failed, linking directly"
        ln -s "$f" $(echo -n $f | replace '/raw/' '/extracted/');
      fi
    done
  ) && \
  (find "$dir/extracted/$1/" -type f -a \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.bmp" -o -iname "*.svg" -o -iname "*.svgz" -o -iname "*.png" -o -iname "*.bmp" -o -iname "*.gif" -o -iname "*.webp" -o -iname "*.avi" -o -iname "*.mp3" -o -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.colors" -o -iname "*.xml" -o -iname "*.xpm" -o -iname "*.icon" -o -iname "*.colorscheme"  -o -iname "*.pdf" -o -iname "*.css" -o -iname "*.scss" -o -iname "*.html" \) -delete 2>/dev/null) && \
  (find "$dir/extracted/$1/" -type f -exec ls -hs {} \; 2>/dev/null | replace "$dir/extracted/" "")
fi

#  (
#  	echo -n $XML | \
#  	xq -e '(.ocs.meta.status == "ok") and (.ocs.data.content.xdg_type | test("theme"))' > /dev/null
#  ) && (
#  	echo -n $XML | \
#  	xq -e '.ocs.data.content.downloadlink1' | \
#  	xargs curl --create-dirs -O  -L --output-dir $dir/raw/$1/
#  ) && echo successfully downloaded $1 && ls -l  $dir/raw/$1/;
# }



