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
sed 's/^/<tr><td>/g' "$sourceFile" | sed 's/,/<\/td><td>/g' | sed 's/$/<\/td><\/tr>/g' >> "$outHtmlFile"
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
