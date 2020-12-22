# How to work with AWS Dynamodb via AWS CLI


##  Table itself

Describe table 
[docs](https://docs.aws.amazon.com/cli/latest/reference/dynamodb/describe-table.html#examples)
```
aws dynamodb describe-table \
    --table-name artapp-dev
```

## Table content

### SELECT

Select all items 
[docs](https://docs.aws.amazon.com/cli/latest/reference/dynamodb/scan.html#examples)
```
aws dynamodb scan \
    --table-name artapp-dev
```

Select specific item: string (`S`) value for partition key `ArtKey` is  `Art_number_1`
[docs](https://docs.aws.amazon.com/cli/latest/reference/dynamodb/get-item.html#examples)
```
aws dynamodb get-item \
    --table-name artapp-dev \
    --key '{
        "ArtKey": {"S":"Art_number_1"}
    }'
```

Select specific item: string (`S`) value for partition key `ArtKey` is  `Art_number_1`
[docs](https://docs.aws.amazon.com/cli/latest/reference/dynamodb/query.html#examples)
```
aws dynamodb query \
    --table-name artapp-dev \
    --key-condition-expression "ArtKey = :name" \
    --expression-attribute-values  '{":name":{"S":"Art_number_1"}}'
```

### PUT

Put item
[docs](https://docs.aws.amazon.com/cli/latest/reference/dynamodb/put-item.html#examples)
```
aws dynamodb put-item \
    --table-name artapp-dev \
    --item file://item.json


# Content of `item.json` file

{
    "ArtKey": {"S": "Art_number_3"},
    "add_col_1": {"S": "already sold"}
}
```

### DELETE 

Delete specific item
[docs](https://docs.aws.amazon.com/cli/latest/reference/dynamodb/delete-item.html#examples)
```
aws dynamodb delete-item \
    --table-name artapp-dev \
    --key file://item.json

  
# Content of `item.json` file
  
{
    "ArtKey": {"S": "Art_number_3"}
}
```
