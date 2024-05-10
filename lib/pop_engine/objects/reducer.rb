module PopEngine
  class Reducer < Object
    alias_attrib_names name: :aname,
                       title_tr: :caption_tr_rdc, # Title of the reducer, translated into the requested language
                       value: :avalue,
                       score_text_tr: :caption_tr_score # Reducer score descriptive text, translated into the requested language

  end
end
