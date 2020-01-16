# iDoklad

This is a ruby gem for Czech accounting cloud system [iDoklad.cz](http://idoklad.cz) api.

You can find official iDoklad.cz api documentation on https://app.idoklad.cz/developer.

## Installation

To install gem write in console:

    > gem install idoklad

Or in Gemfile:

    gem 'idoklad'

## Configuration

To get gem working you must create an iDoklad initializer file and insert **client_id** and **client_secret** values which you can obtain in [iDoklad.cz administration](https://app.idoklad.cz/Setting/LogonUser).  
Create *config/initializers/idoklad.rb* file with following content:

    # config/initializers/idoklad.rb

    require 'idoklad'
    Idoklad.configure do |c|
      c.client_id = **INSERT_YOUR_CLIENT_ID**
      c.client_secret = **INSERT_YOUR_CLIENT_SECRET**
    end

Of course replace **\*\*INSERT_YOUR_CLIENT_ID\*\*** and **\*\*INSERT_YOUR_CLIENT_SECRET\*\*** with proper values.

## Functionality

- [Getting List of Invoices](#getting-list-of-invoices)
- [Getting the Default Invoice](#getting-default-invoice)
- [Creating Invoice](#creating-invoice)

### Getting List of Invoices

It returns the list of all issued invoices:

    @result = Idoklad::Entities::IssuedInvoice.all
    
#### Filtering
Find specify invoice by number

    @result = Idoklad::Entities::IssuedInvoice.find_by DocumentNumber: "TE20200001"
    
Find all invoice of specify contact 

    @result = Idoklad::Entities::IssuedInvoice.where filter: {PurchaserId: "8147313"}

### Getting Default Invoice

Returns an empty invoice with initial values according to the agenda settings. Good for issuing new invoice.

    @result = Idoklad::Entities::IssuedInvoice.default

### Creating Invoice

Creates a new invoice and returns whole response:

    invoice = Idoklad::Entities::IssuedInvoice.default
    invoice.name = "..."
    invoice.save # => true
    invoice.partner_id = nil
    invoice.save # => false
    invoice.errors # => ["Error converting value {null} to type 'System.Int32'"]

## Contribution

The functionality is being added as I find it required. If you want to contribute or you want me to add some functionality, just [write me](http://coderocket.co).
