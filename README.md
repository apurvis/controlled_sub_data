# Controlled Sub Data
---
A basic CRUD application to help the Immigrant Defense Project collate information on discrepancies between state and federal controlled substance statutes.

## Naming Conventions

A statute's string identifier is created by concatenating its state (or federal) and its effective date.

String identifiers for amendments to statutes are identified by the statute identifier plus "Amended <DATE>".

### On spelling discrepancies

If there are spelling discrepancies for a substance name between different statutes, you should create two different statutes.

## Data Model

There are at heart substances and statutes.

### Substances
A ```Substance``` record just contains data about the substance being regulated.

### Statutes
```Statute``` contains info about the law (name, effective date, blue book code) and links to substances regulated by said law (and how they are regulated - e.g. if the regulations also regulates stereo isomers, that will be captured here) via the ```SubstanceStatute``` object.

## Usage

### Creating Statutes

When you create a statute, you must provide all of the following:

* State (or FEDERAL)
* Effective Date
* Blue Book Code

You then add substances to the statute by clicking on "Add a substance to this statute"

You can edit the blue book code, effective date, etc by clicking "Edit this statute"

You also have the option of choosing a "Duplicate FEDERAL as of date".  If you choose this option, all Federally scheduled substances scheduled prior to this date will be considered part of the new statute.  NOTE THAT THIS IS NOT A COPY!  Any changes to the underlying FEDERAL statutes will automatically be propagated downstream!

### Amending Statutes

Under the hood, statute amendments are just statutes with a parent statute that they are amending.

You then add/remove substances to the statute by clicking on "Add a substance to/Expire a substance from this statute".  To amend statutes in ways that expire scheduling of substance, check is "Is this an expiration?" checkbox

### Search for Statutes

You can search for statutes by substance, and you can specify an optional "As of date".  All statutes applying to the substance and starting before the "as of date" will be displayed.

## Technical Info

This application requires:

- Ruby 2.2.2
- Rails 4.2.3
