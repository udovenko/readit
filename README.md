# Readit

> **In development**

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
  content: '<p><b>Warning!</b> We're temporary stopping sales due to coming Armageddon!</p>',
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
This will make **@announcements** collection available in your views. Having collection available, you can render announcement partial:

```ruby
<%= render partial: 'readit/announcement', collection: @announcements %>
```