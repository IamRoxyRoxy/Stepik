#!/bin/bash


# количество запросов
echo "количество запросов:"
wc -l access.log

# количество различных IP
echo "количество различных IP:"
awk '{
  gsub(/"/, "");
  key = $1 " " $6;
  seen[key] = 1;
}
END {
  count = 0;
  for (k in seen) count++;
  print count;
}' access.log

# 