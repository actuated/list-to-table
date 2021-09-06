#!/bin/bash
# list-to-table.sh
# 8/7/2021 by Ted R (http://github.com/actuated)
# Shell script to convert a list of items to an HTML table
# 8/10/2021 - Changed output/temp file format to better support other platforms

sortOptions="-Vu"

function fnUsage {
  echo
  echo "========================================[ about ]========================================"
  echo
  echo "Shell script for converting a list from input file to an intentionally-basic HTML table."
  echo "Does sort -Vu on input, modify 'sortOptions' variable in beginning of script to change."
  echo
  echo "========================================[ usage ]========================================"
  echo
  echo "./list-to-table.sh [input file] [number of columns]"
  echo
  echo "=========================================[ fin ]========================================="
  echo
  exit  
}

echo
echo "=====================[ list-to-table.sh - Ted R (github: actuated) ]====================="

# Set source file
sourceFile="$1"

# Check source file
if [ "$sourceFile" = "" ]; then
  echo
  echo "Error: No source file given."
  fnUsage
fi

outDate=$(date +%F-%H-%M)
outName=$(basename "$sourceFile")
outTempFile="table-$outName-$outDate.temp"
outHtmlFile="table-$outName-$outDate.html"

# Get and check number of columns
numColumns="$2"
if [[ ! "$numColumns" =~ ^[0-9]+$ ]] || [[ "$numColumns" == 0 ]]; then
  echo
  echo "Error: Number of columns ('$numColumns') not an integer >= 1."
  fnUsage
fi

# Make sure temp file does not exist
if [ -f "$outTempFile" ]; then
  rm "$outTempFile"
fi

# Make sure output file does not exist
if [ -f "$outHtmlFile" ]; then
  rm "$outHtmlFile"
fi

# Create sorted temp file and get count
sort $sortOptions "$sourceFile" | grep . --color=never > "$outTempFile"
numItems=$(wc -l < "$outTempFile")

# Figure out if there will be any filler cells
numFullRows=$(( $numItems / $numColumns ))
totalItemsInFullRows=$(( $numFullRows * $numColumns ))
numLastRowInput=$(( $numItems - $totalItemsInFullRows ))
numLastRowFiller=$(( $numColumns - $numLastRowInput ))

# Begin HTML document
echo "<html><body><table>" >> "$outHtmlFile"

# Loop through populated table cells
thisColumnNumber=1
while read -r thisLine; do
  if [[ "$thisColumnNumber" == "1" ]]; then
    echo "<tr>" >> "$outHtmlFile"
  fi
  echo "<td>$thisLine</td>" >> "$outHtmlFile"
  if [[ "$thisColumnNumber" == "$numColumns" ]]; then
    echo "</tr>" >> "$outHtmlFile"
    thisColumnNumber=0
  fi
  let thisColumnNumber=thisColumnNumber+1
done < "$outTempFile"

# Insert any filler cells
if [[ "$numLastRowInput" != "0" ]]; then
  thisFillerCell=1
  while [ $thisFillerCell -le $numLastRowFiller ]; do
    echo "<td></td>" >> "$outHtmlFile"
    if [[ "$thisFillerCell" == "$numLastRowFiller" ]]; then
      echo "</tr>" >> "$outHtmlFile"
    fi
    let thisFillerCell=thisFillerCell+1
  done
fi

# End HTML document
echo "</table></body></html>" >> "$outHtmlFile"

# Prompt to open document
if [ -f "$outHtmlFile" ]; then 
  echo
  echo "$outHtmlFile created."
  read -p "Open $outHtmlFile using sensible-browser? [Y/N] " doOpenHTML
  case "$doOpenHTML" in
    y | Y)
      sensible-browser "$outHtmlFile" >/dev/null 2>&1 &
      ;;
  esac
fi

# Clean up temp file
if [ -f "$outTempFile" ]; then
  rm "$outTempFile"
fi

echo
echo "=========================================[ fin ]========================================="
echo

