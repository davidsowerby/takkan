const serverSchema={
  "results": [
    {
      "className": "_User",
      "fields": {
        "objectId": {
          "type": "String"
        },
        "createdAt": {
          "type": "Date"
        },
        "updatedAt": {
          "type": "Date"
        },
        "ACL": {
          "type": "ACL"
        },
        "username": {
          "type": "String"
        },
        "password": {
          "type": "String"
        },
        "email": {
          "type": "String"
        },
        "emailVerified": {
          "type": "Boolean"
        },
        "authData": {
          "type": "Object"
        }
      },
      "classLevelPermissions": {
        "find": {
          "*": true
        },
        "count": {
          "*": true
        },
        "get": {
          "*": true
        },
        "create": {
          "*": true
        },
        "update": {
          "*": true
        },
        "delete": {
          "*": true
        },
        "addField": {
          "*": true
        },
        "protectedFields": {
          "*": []
        }
      },
      "indexes": {
        "_id_": {
          "_id": 1
        },
        "case_insensitive_username": {
          "username": 1
        },
        "username_1": {
          "username": 1
        },
        "email_1": {
          "email": 1
        },
        "case_insensitive_email": {
          "email": 1
        }
      }
    },
    {
      "className": "_Role",
      "fields": {
        "objectId": {
          "type": "String"
        },
        "createdAt": {
          "type": "Date"
        },
        "updatedAt": {
          "type": "Date"
        },
        "ACL": {
          "type": "ACL"
        },
        "name": {
          "type": "String"
        },
        "users": {
          "type": "Relation",
          "targetClass": "_User"
        },
        "roles": {
          "type": "Relation",
          "targetClass": "_Role"
        }
      },
      "classLevelPermissions": {
        "find": {
          "*": true,
          "requiresAuthentication": true
        },
        "count": {
          "*": true,
          "requiresAuthentication": true
        },
        "get": {
          "*": true,
          "requiresAuthentication": true
        },
        "create": {
          "requiresAuthentication": true
        },
        "update": {},
        "delete": {},
        "addField": {},
        "protectedFields": {
          "*": []
        }
      },
      "indexes": {
        "_id_": {
          "_id": 1
        },
        "name_1": {
          "name": 1
        }
      }
    },
    {
      "className": "Person",
      "fields": {
        "objectId": {
          "type": "String"
        },
        "createdAt": {
          "type": "Date"
        },
        "updatedAt": {
          "type": "Date"
        },
        "ACL": {
          "type": "ACL"
        },
        "name": {
          "type": "String",
          "required": false
        },
        "nameWithDefault": {
          "type": "String",
          "required": false,
          "defaultValue": "aDefaultValue"
        },
        "nameRequired": {
          "type": "String",
          "required": true
        },
        "number": {
          "type": "Number",
          "required": false
        },
        "date": {
          "type": "Date",
          "required": false
        },
        "object": {
          "type": "Object",
          "required": false
        },
        "array": {
          "type": "Array",
          "required": false
        },
        "geoPoint": {
          "type": "GeoPoint",
          "required": false
        },
        "polygon": {
          "type": "Polygon",
          "required": false
        },
        "file": {
          "type": "File",
          "required": false
        },
        "pointToUser": {
          "type": "Pointer",
          "targetClass": "_User",
          "required": false
        },
        "relationToUser": {
          "type": "Relation",
          "targetClass": "_User",
          "required": false
        },
        "extraField": {
          "type": "String",
          "required": false
        }
      },
      "classLevelPermissions": {
        "find": {
          "role:author": true,
          "requiresAuthentication": true,
          "role:editor": true
        },
        "count": {
          "role:author": true,
          "role:editor": true
        },
        "get": {
          "role:author": true,
          "role:editor": true,
          "*": true
        },
        "create": {
          "role:author": true,
          "role:editor": true,
          "requiresAuthentication": true
        },
        "update": {
          "role:editor": true
        },
        "delete": {
          "role:author": true,
          "role:editor": true
        },
        "addField": {
          "requiresAuthentication": true
        },
        "protectedFields": {
          "*": []
        }
      },
      "indexes": {
        "_id_": {
          "_id": 1
        },
        "polygon_2dsphere": {
          "polygon": "2dsphere"
        }
      }
    }
  ]
};