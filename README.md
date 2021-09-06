# list-to-table
Shell script to convert an input list to a bare bones HTML table.

Meant as a way to replicate Word's "Convert Text to Table" feature.

# Usage

```
./list-to-table.sh [input file] [number of columns]
```
* Both arguments are required, this is fairly basic.
* **[input file]** is expected to be a text file with one item per line, such as a list of IPs affected by a vulnerability.
* **[number of columns]** must be given, and must be an integer >0.
* The script will do a `sort -Vu` on the items first. There is a `sortOptions` variable set at the top of the script (to `-Vu`) you can modify if you insist.
  - `sort -Vu` is great for IPs in particular, the "version number" sorting puts them in the right order, and obviously uniquing the items is useful.
* The output is an HTML file named `table-[input file basename]-YYYY-MM-DD-HH-MM.html`.
  - There is intentionally no styling or formatting, it's a bare HTML table for pasting into web-based rich text reporting tools.
  - The last row will be padded with empty table cells as needed. Our design criteria was an empty cell in each column, rather than colspan'ing one.
* The script will offer to launch the HTML file with `sensible-browser`, this obviously depends on your support for that.
