# Page Types

Precept provides several page configuration types, and these will cover most circumstances when used with `PreceptPage`

The table below illustrates typical usage.

| Definition   | Typical usage                                                                                                                                       |
|--------------|-----------------------------------------------------------------------------------------------------------------------------------------------------|
| PPage [:point_right:](#PPage)    | Any form, for example for setting preferences and options                                                                                           |
| PListPage  [:point_right:](#plistpage)  | Any full page list, often to select an item for viewing / editing                                                                                   |
| PGridPage [:point_right:](#pgridpage) | Any page which uses more than one data source, for example, your account page with panels for today's temperature and the best scores in your game. |


## PPage

- A single data source for the whole page
- The page can be divided into [panels](#panel), each with an optional, collapsible heading
- Edit / Save / Cancel functionality is provided
- Panels can be put into edit mode separately, or all at the same time
- Precept takes care of passing edited data back to the data source.  

## PListPage

- A full page list
- A single data source for the whole page
- May be used to navigate by tapping on an item 

## PGridPage

- Provides a flexible Grid structure
- Every cell contains a Panel
- Individual cells can be placed in edit mode by tapping on them

## Custom Pages

If these are not sufficient you can create your own `Page` type (as opposed to `PPage`) and [register](./libraries.md#registering-with-a-library) them with the [PageLibrary](./libraries.md)

You can then extend `PPage` (if you need to) to configure your design. [:thinking:](https://gitlab.com/precept1/precept-client/-/issues/24) 