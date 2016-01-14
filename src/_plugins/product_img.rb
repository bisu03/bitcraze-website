module Jekyll
  class ProductImg < Liquid::Tag

    # Use this tag on product pages for the images at the top
    #
    # ; is used as separator
    #
    # Takes 2 main argumant
    # - Product name
    # - Image width
    #
    # And 1 arguments per image
    # - Image path
    #
    # Example
    # {% product_img The fancy product; medium;
    # /images/fancy-product-front.jpg;
    # /images/fancy-product-back.jpg;
    # /images/fancy-product-top.jpg
    # %}

    def initialize(tag_name, text, tokens)
      super
      params = split_strip(text, ';')

      @title = params[0]
      @width = params[1]
      @images = params[2..-1]
    end

    def render(context)
      if @images.length == 1
        render_single(@images[0], @width, @title)
      else
        render_multiple(@images, @width, @title)
      end
    end


    def render_single(image, width, title)
      '<img class="pp-main-image-%1$s"
       src="%2$s"
       alt="%3$s"
       title="%3$s"/>' % [width, image, title]
    end

    def render_multiple(images, width, title)
      result = '<div id="carousel-images" class="carousel slide pp-main-image-%1$s" data-interval="false">' % [width]
      result += '<ol class="carousel-indicators">'

      clazz = ' class="active"'
      for index in 0...images.length
        result += '<li data-target="#carousel-images" data-slide-to="%1$s"%2$s></li>' % [index, clazz]
        clazz = ''
      end

      result += '</ol>'
      result += '<div class="carousel-inner" role="listbox">'

      clazz = ' active'
      images.each do |image|
        result += '<div class="item%1$s"><img src="%2$s" alt="%3$s"></div>' % [clazz, image, title]
        clazz = ''
      end

      result += '</div>
<a class="left carousel-control" href="#carousel-images" role="button" data-slide="prev"><span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span><span class="sr-only">Previous</span></a>
<a class="right carousel-control" href="#carousel-images" role="button" data-slide="next"><span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span><span class="sr-only">Next</span></a>
</div>'

    end

    def split_strip(str, token)
      parts = str.split(token)
      parts.map {|part| part.strip}
    end
  end
end

Liquid::Template.register_tag('product_img', Jekyll::ProductImg)