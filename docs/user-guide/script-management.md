# Script Management

`Script` and `Schema` are the design of an application, and as such require version controlled management.

They are controlled separately, since it is entirely feasible that a change may be made to either without making a change to the other.

:::tip Note

When we refer to 'scripts' here, we mean both `Script` and `Schema` instances.

:::

##  Storing Scripts

Scripts could be held anywhere that your client can access, and the choice is yours.  The Back4App implementation provides
for holding the scripts in a Back4App instance. 
 

## Internationalization

The conventional approach to localisation is to translate on the client, which is not very efficient - most users only ever use a single Locale setting.

Takkan takes a different approach, and expects the translation to be done server-side. [Interpolation](#interpolation), being dynamic, still has to be carried out on the client.

This is particularly relevant to any [static](takkan-script.md#dynamic-vs-static-data) data defined by a `Script`.


## Remote Update





## Interpolation

 
TBW