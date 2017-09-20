require "./tags/**"

module LuckyWeb::Page
  include LuckyWeb::BaseTags
  include LuckyWeb::LinkHelpers
  include LuckyWeb::FormHelpers
  include LuckyWeb::LabelHelpers
  include LuckyWeb::InputHelpers
  include LuckyWeb::SpecialtyTags
  include LuckyWeb::Assignable
  include LuckyWeb::AssetHelpers

  macro included
    SETTINGS = {} of Nil => Nil
    ASSIGNS = {} of Nil => Nil

    macro inherited
      SETTINGS = {} of Nil => Nil
      ASSIGNS = {} of Nil => Nil

      inherit_page_settings
    end
  end

  macro inherit_page_settings
    \{% for k, v in @type.ancestors.first.constant :ASSIGNS %}
      \{% ASSIGNS[k] = v %}
    \{% end %}

    \{% for k, v in @type.ancestors.first.constant :SETTINGS %}
      \{% SETTINGS[k] = v %}
    \{% end %}
  end

  macro layout(layout_class)
    {% SETTINGS[:has_layout] = true %}
    def render
      {{layout_class}}.new(self, @view).render.to_s
    end
  end

  macro render
    {% if SETTINGS[:has_layout] %}
      {% render_method_name = :render_inner %}
    {% else %}
      {% render_method_name = :render %}
    {% end %}
    def {{ render_method_name.id }}
      {{ yield }}
      @view
    end

    generate_initializer
  end
end
