# Controlled Sub Data

A basic CRUD application to help the Immigrant Defense Project and other public defender offices collate information on discrepancies between state and federal controlled substance statutes.

### Naming Conventions

A statute's string identifier is created by concatenating its state (or federal) and its effective date.

String identifiers for amendments to statutes are identified by the statute identifier plus "Amended <DATE>".

### On spelling discrepancies

If there are spelling discrepancies for a substance name between different statutes, you should create two different statutes, because it's unclear right now that this is not a substantive difference.

---

## Data Model

There are at heart ```Substances``` and ```Statutes```.  ```Statutes``` regulate many ```Substances``` and they are linked by ```SubstanceStatute``` records.

### Substances
A ```Substance``` record just contains data about the substance being regulated and nothing about the regulations.

### Statutes
A ```Statute``` contains info about the law (name, effective date, blue book code) and links to substances regulated by that law through ```SubstanceStatute``` records.

It also contains links to a rolling change log in the form of ```StatuteAmendments``` which are records of how a Statute has evolved over time.

```StatuteAmendments``` have an effective date and can contain substance additions (e.g. a new substance was scheduled), substance expirations, changes in schedule level for a given substance.

### SubstanceStatutes
A ```SubstanceStatute``` record contains information about how a particular ```Statute``` applies to a particular ```Substance```.  Things like whether the the ```Statute``` (or amendment) also regulated stereo isomers/preparations/whatever, comments about application, and more.

### SubstanceAlternateName
A ```SubstanceAlternateName``` is another string that is attached to a ```SubstanceStatute```.  It is an "AKA" or equivalent string for that substance as it is regulated by that statute.

---

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

### Adding/Expiring Substances to Statutes or Statute Amendments

1. If the substance doesn't exist in the database yet, you must create a record for it through the Substances page.
2. From the Statute page, click "Add/expire a substance".
3. Choose a substance from the drop down.
  * If this amendment is expiring this substance's scheduling, check the "is an expiration" box
  * If this amendment is changing this substance's schedule level, input a new value in the schedule level box.

### Adding Alternate Names

Navigate to a SubstanceStatute; click "Add alternate name".

### Search for Statutes

You can search for statutes by substance, and you can specify an optional "As of date".  All statutes applying to the substance and starting before the "as of date" will be displayed.

Alternate names will appear in the list of substances (but link to search results for the canonical substance name)

## Technical Info

This application requires:

- Ruby 2.2.2
- Rails 4.2.3
