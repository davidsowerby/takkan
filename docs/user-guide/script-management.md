# Script Management

`PScript` and `PSchema` are the design of an application, and as such require version controlled management.

They are controlled separately, since it is entirely feasible that a change may be made to either without making a change to the other.

:::tip Note

When we refer to 'scripts' here, we mean both `PScript` and `PSchema` instances.

:::

##  Storing Scripts

Scripts could be held anywhere that your client can access, and the choice is yours.  The Back4App implementation provides
for holding the scripts in a Back4App instance. 
 

## Internationalization

The conventional approach to localisation is to translate on the client, which is not very efficient - most users only ever use a single Locale setting.

Precept takes a different approach, and expects the translation to be done server-side. [Interpolation](#interpolation), being dynamic, still has to be carried out on the client.

This is particularly relevant to any [static](precept-script.md#dynamic-vs-static-data) data defined by a `PScript`.


## Remote Update





## Interpolation

 
TBW