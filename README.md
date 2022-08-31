# README

This is an insane Rails starter kit that shows some of the ways you can use [Sitepress](https://sitepress.cc) within your Rails app.

You can, and should, view Awesome Sauce at https://awesome-sauce.fly.dev. There you will see links that bring you back to the source code under "Page" in the footer.

## Demo points

This application demos a few things:

### Content is all in `./app/content`

Everything a content team would need to edit for content is in the [`./app/content`](./app/content) folder. Pages, helpers, templates, partials, and page models are all there. Your content folks could only edit files in that directory and get pretty far.

To enforce that only marketing or content folks can edit content, a [CODEOWNER](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners) file could be setup that requires them to work through a PR to edit stuff outside of that folder.

### Routes

Sitepress has the following route helpers:

```ruby
Rails.application.routes.draw do
  sitepress_pages
  sitepress_root
end
```

If you put a page in `./app/content/index.html.erb` it will appear when you open `/`. If you put a page at `./app/content/support/printers.html.erb`. it will appear at `/support/printers` without touching the routes file.

### Pages are objects

It's important to think of pages as objects that have metadata as Frontmatter and content as the body. This makes it possible to loop through pages all over the Rails views like this:

```slim
.grid.md:grid-cols-3.gap-8
  -TestimonialPage.all.each do |testimonial|
    =link_to testimonial.request_path, class: "rounded-lg drop-shadow-md hover:drop-shadow-xl" do
      =image_tag testimonial.image, class: "rounded-t-lg"
      .p-4.bg-white
        quote=testimonial.quote
        .ml-4.mt-4. - #{testimonial.title}
```

#### Frontmatter metadata

The metadata of those pages in the loop above look like this:

```md
---
title: Cow
layout: testimonial
quote: Moo! Moo mooo moo moooooo mooo moo for Awesome Sauce!
images:
  - cow-by-mansion.png
  - cow-in-back.png
  - cow-wealthy.png
---

I use to be a dairy cow, then I tried Awesome Sauce and it changed my life. Now I live in a mansion and drive around this sweet convertible that you probably had when you were in High School.
```

The data up top, as denoted by the `---` is parsed out and accessible from any page via `current_page.data`. That means you can do stuff like this:

```slim
h1.text-3xl.font-bold=current_page.data.fetch("title")
```

Or this:

```slim
.grid.grid-cols-3
  p Meet my cousins
  -current_page.siblings.collect{ |page| page.data.fetch("images") }.flatten.each do |image|
    =image_tag image
```

#### Page Models

If you get tired of `page.data.fetch("blah")` or doing stuff like `"#{page.data.fetch("first_name")} #{page.data.fetch("last_name")}"` you can break out page models, which wrap pages in a class that you can use to do more complicated things like this:

```ruby
class PersonPage < Sitepress::Model
  collection glob: "people/*.html*"
  data :first_name, :last_name

  def name
    "#{first_name} #{last_name}"
  end
end
```

Then loop through it anywhere like this:

```slim
ul
  -PersonPage.all.each do |person|
    li=person.name
```

And you'll get their name!

### Site tree

Implementing relative navigation is easy in Sitepress. If you want to link to the parent page, just do this:

```slim
=link_to "Go up one level", current_page.parent.request_path
```

Want to link to all the pages directly below your homepage? Cool.

```slim
h2 Menu
ul
  -current_page.children.each do |page|
    li=link_to page, page.data.fetch("title")
```

Your site is a tree, so treat it like one!

### Ok cool, but why put content in your Rails site?

Lots of reasons! Every website that's doing anything interesting has static content that needs to be mangage such as:

#### Teams page

Create the `./app/content/pages/teams/` directory and throw in files that look like this:

```md
---
name: Brad Gessler
urls:
  twitter: https://twitter.com/bradgessler
  github: https://github.com/bradgessler
image: brad.jpg
---

Hi! I'm Brad, I created this insane website and Sitepress.
```

Then bang out a template that looks like this:

```slim
h1=current_page.data.fetch("name")
.prose=yield
=image_tag current_page.data.fetch("image", "no-image.jpg")
h2 Check out my socials:
ul
  -current_page.data.fetch("urls", {}).each do |site, url|
    li=link_to site, url
```

#### Boring legal stuff

You saw it at [./app/content/pages/legal](./app/content/pages/legal)

#### Inline docs

The help docs in this repo could have Frontmatter added that looks like this:

```
title: Recall
objective: Learn more about government recalls of Awesome Sauce
customer_segments:
  - enterprise
  - higher-ed
```

Then, from anywhere in your Rails application, say in your app pages, you could have a helper that displays links contextually:

```ruby
HelpPages.all.select { |help| help.data["tags"].includes? "higher-ed" }
```

The context can be however you want to slice and dice it. Page Models can even hide some of the complexity such that the code above looks like this:

```slim
h2 Get help!
ul
  -HelpPages.tags("higher-ed", "enterprise").each do |help|
    li=link_to_page help
```

The `HelpPages.tags` would look like this:

```ruby
class HelpPages < Sitepress::Model
  collection glob: "help/*.html*"

  def tags
    Set.new(data.fetch("tags"))
  end

  def self.tags(*tags)
    tags = Set.new(tags)
    all.select { |help| help.tags | tags }
  end
end
```

When content like this is coupled very closely with the application, amazing things can happen.

#### More

The list goes on...

* Video library
* Example projects
* Use cases
* Customer testimonials

### Photographs

No animals were harmed during the photographing of Awesome Sauce testimonials. They were all generated via DALL-E, which is why this site got a little weird.