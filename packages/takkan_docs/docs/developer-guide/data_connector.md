| parent              | Data  | produces                                                                 | checks |
|---------------------|--------|--------------------------------------------------------------------------|--------|
| NullDataConnector   | static | static with NullDataConnector parent                                     |        |
|                     | root   | DataRoot                                                                 |        |
|                     | other  | fails - no root                                                          |        |
| StaticDataConnector | static | StaticDataConnector with StaticDataConnector parent                      |        |
|                     | root   | DataRoot                                                                 |        |
|                     | other  | fails, unless an ancestor is DataRoot                                    |        |
| DataRoot            | static | StaticDataConnector with DataRoot parent                                 |        |
|                     | root   | DataRoot from Data.  New branch                                         |        |
|                     | other  | DefaultDataConnector with dataRoot pointing to parent                    |        |
| Other               | static | StaticDataConnector with DefaultDataConnector parent                     |        |
|                     | root   | DataRoot from Data.  New branch                                         |        |
|                     | other  | DefaultDataConnector, root from parent, binding from parent modelBinding |        |
|                     |        |                                                                          |        |