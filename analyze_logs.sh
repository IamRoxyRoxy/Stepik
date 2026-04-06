#!/bin/bash

# файл отчёта
REPORT="report.txt"

: > "$REPORT"

echo "Отчет о логе веб-сервера
========================" >> "$REPORT"

# количество запросов
{
  echo -n "Общее количество запросов:"
  wc -l < access.log
} >> "$REPORT"

# количество различных IP
{
  echo -n "Количество уникальных IP-адресов:"
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
} >> "$REPORT"

# Количество запросов по методам:
{
  echo "Количество запросов по методам:"
  awk '{
  gsub(/"/, "", $6); 
  method = $6;
  count[method]++;
	}
END {
  for (m in count) {
    print count[m], m;
  }
}' access.log | sort -r
} >> "$REPORT"

# Самый популярный URL
{
  echo -n "Самый популярный URL: "
  awk '{
  # $7
  url = $7
  count[url]++
	}
 END {
  max_url = ""
  max_cnt = 0
  for (u in count) {
    if (count[u] > max_cnt) {
      max_cnt = count[u]
      max_url = u
    }
  }
  print max_cnt, max_url
}' access.log
} >> "$REPORT"
  
  
echo "Отчет сохранен в файл " $REPORT