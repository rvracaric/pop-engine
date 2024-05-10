module PopEngine
  class Trait < Object
    alias_attrib_names name: :trait_name,
                       title_tr: :caption_tr # Trait title translated into requested language
  end
end
