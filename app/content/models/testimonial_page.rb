class TestimonialPage < Sitepress::Model
  collection glob: "testimonials/*.html.*"
  data :title, :images, :quote

  def image
    images.sample
  end
end

