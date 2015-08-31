# Readit

**Readit** brings simple announcements to your application. It uses cookie to store read announcements data and does not require authentication gems. Cookie contains content hash for each read announcement so if model was edited when user already read its content, he will see updated announcement again.

Currently announcements use **Bootstrap** layout, but you can override default partial according to your needs.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'readit', github: 'udovenko/readit'
```
And then execute:

    $ bundle install
    $ rails g readit:install

Last command will mount engine route and copy required migrations. When install generator will finish its work, migrate your database:

    $ rake db:migrate

Now you can update your code to use announcements in your application.

## Usage

Use **Readit::Announcement** model for CRUD operations with your announcements:

```ruby
Readit::Announcement.create {
  content: "<p><b>Warning!</b> We're temporary stopping sales due to coming Armageddon!</p>",
  start_at: Time.now,
  stop_at: 100.days.from_now,
  is_active: true }
```

As you can see, **content** can contain HTML tags. **start_at** and **stop_at** determine time range during which your announcement will be showed if it is active.

To add announcements partial into your template you need to set a collection of active unread announcements in the controller. To do so include **Readit::Announcements** module in it:

```ruby
class SomeController < ApplicationController
  include Readit::Announcements
  ...
```
This will make **@announcements** collection available in your views. By default it queries data before each action of controller, so if you have any actions which do not render templates and just redirect user away, it is a good idea to skip callback for them:

```ruby
  ...
  include Readit::Announcements
  skip_before_action :set_announcements, only: [:create, :update]
  ...
``` 

Having collection available, you can render announcement partial:

```ruby
<%= render partial: 'readit/announcement', collection: @announcements %>
```

## Registering in ActiveAdmin

If you want to register **Readit** announcements as an **ActiveAdmin** resource, you need to fix resource name in configuration, otherwise you will not be able to create and update models form **ActiveAdmin** form. This issue is related to returning value of **param_key** method which is specific for isolated namespaces. See https://github.com/activeadmin/activeadmin/issues/3161 for details.

Add the following to your resource definition and resource actions should work correctly:

```ruby
ActiveAdmin.register Readit::Announcement do
  ...

  controller do
    resources_configuration[:self][:instance_name] = 'announcement'
  end
  ...
```

## I18n

Gem initially contains some English and Russian translations. Since **Readit** classes are typical models, controllers and views, you can add your own and overwrite existing translations by following **Rails** I18n conventions:

```ruby
en:
  readit:
    announcement:
      hide_announcement: "I've read it, don't show again"
  ...    
```
See **config/locales/en.yml** and **config/locales/ru.yml** form more examples.

## Contributing

1. Fork it ( https://github.com/udovenko/readit/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request