# Server Code

## Notes

### Getting the Schema

This gets the whole schema

``` javascript
    const s = await new Parse.Schema('_User').get();

```

The following gets the whole schema *except* the CLP.  A bit odd!


``` javascript
    const s = await new Parse.Schema('_User');

```

**BUT:**

*purge* and *delete* only work with :

``` javascript
    const s = await new Parse.Schema('MyClass');

```

### Schema Save vs Update

Save will reject if the schema name already exists.

Update really is just that.