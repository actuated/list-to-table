#!/bin/bash
# csv-to-table.sh
# 2/17/2022 by Ted R (http://github.com/actuated)
# Shell script to convert a CSV file to an HTML table

function fnUsage {
  echo
  echo "========================================[ usage ]========================================"
  echo
  echo "./csv-to-table.sh [input file]"
  echo
  echo "=========================================[ fin ]========================================="
  echo
  exit  
}

echo
echo "=====================[ csv-to-table.sh by Ted R (github: actuated) ]====================="

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
outHtmlFile="table-$outName-$outDate.html"

# Make sure output file does not exist
if [ -f "$outHtmlFile" ]; then
  rm "$outHtmlFile"
fi

# Open/close HTML doc and sed CSV lines to table rows
echo "<html><body><table>" >> "$outHtmlFile"
# Check maximum number of CSV columns
maxCols=$(awk -F , '{print NF}' "$sourceFile" | sort | tail -n 1)
# Check each line
while read thisLine; do
  # Get this line's column count and any necessary fill count
  thisCols=$(echo "$thisLine" | awk -F , '{print NF}')
  fillCount=$(( "$maxCols" - "$thisCols" ))
  # Start row
  echo "<tr><td>" >> "$outHtmlFile"
  # Replace commas with cell close/open tags
  echo "$thisLine" | sed 's/,/<\/td><td>/g' >> "$outHtmlFile"
  # Check for fill count
  if [ "$fillCount" -gt "0" ]; then
    countFillCols=0
    while [ "$countFillCols" -lt "$fillCount" ]; do
      echo "</td><td>"  >> "$outHtmlFile"
      countFillCols=$(( $countFillCols + 1 ))
    done
  fi
  # End row
  echo "</td></tr>" >> "$outHtmlFile"
done < "$sourceFile"
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

echo
echo "=========================================[ fin ]========================================="
echo
