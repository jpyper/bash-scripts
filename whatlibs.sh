#!/usr/bin/env bash





# location of 'readelf' binary
wl_readelf="$(type -P readelf)"

# location of 'grep' binary
wl_grep="$(type -P grep)"

# location of 'sort' binary
wl_sort="$(type -P sort)"





# tear open the beastly binary to see what's inside
echo
${wl_readelf} -d "${1}" | ${wl_grep} NEEDED | ${wl_sort}
echo
