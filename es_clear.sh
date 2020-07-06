#!/bin/bash

indexs=` curl -X GET 'http://es-cn-nif1pv8pd000kfcfm.elasticsearch.aliyuncs.com:9200/_cat/indices?v' -u elastic:tq4jpF7+XLS8g| awk '{print $3}' | grep -vE '(monitoring|log)'`

for index in $indexs
  do
     curl  -X POST "es-cn-nif1pv8pd000kfcfm.elasticsearch.aliyuncs.com:9200/$index/_delete_by_query?pretty" -H 'Content-Type:application/json' -u 'elastic:tq4jpF7+XLS8g' -d '
      {
         "query": { 
              "bool": {
                   "must": [
                      {
                        "range": {
                           "@timestamp": {
                               "lt": "now-30d",
                               "format": "epoch_millis"
                              }
                         }
                     }
                   ],
                   "must_not": []
              }  
         }  
     }'
     echo "已清除$index 索引内三十天前数据~"
   done