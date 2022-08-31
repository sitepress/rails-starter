# README

This is an insane Rails starter kit that shows some of the ways you can use [Sitepress](https://sitepress.cc) within your Rails app.

You can, and should, view Awesome Sauce at https://awesome-sauce.fly.dev. There you will see links that bring you back to the source code under "Page" in the footer.

## Demo points

This application demos a few things:

### Content is all in `./app/content`

Everything a content team would need to edit for content is in the [`./app/content`](./app/content) folder. Pages, helpers, templates, partials, and page models are all there. Your content folks could only edit files in that directory and get pretty far.

To enforce that only marketing or content folks can edit content, a [CODEOWNER](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners) file could be setup that requires them to work through a PR to edit stuff outside of that folder.

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

### Photographs

No animals were harmed during the photographing of Awesome Sauce testimonials. They were all generated via DALL-E, which is why this site got a little weird.