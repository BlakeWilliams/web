require "../../spec_helper"

class FormHelpers::Index < LuckyWeb::Action
  action { render_text "foo " }
end

class FormHelpers::Update < LuckyWeb::Action
  action { render_text "foo " }
end

class FormHelpers::Create < LuckyWeb::Action
  action { render_text "foo" }
end

private class TestPage
  include LuckyWeb::Page

  render do
  end

  def inferred_put_form
    form_for FormHelpers::Update.route("fake_id") do
      text "foo"
    end
  end

  def inferred_post_form
    form_for FormHelpers::Create.route do
      text "foo"
    end
  end

  def inferred_get_form
    form_for FormHelpers::Index.route do
      text "foo"
    end
  end

  def form_with_html_options
    form_for FormHelpers::Create.route, class: "cool-form" do
      text "foo"
    end
  end
end

describe LuckyWeb::FormHelpers do
  it "renders a form tag" do
    view.inferred_put_form.to_s.should contain <<-HTML
    <form action="/form_helpers/fake_id" method="post"><input type="hidden" name="_method" value="put"/> foo </form>
    HTML

    view.inferred_post_form.to_s.should contain <<-HTML
    <form action="/form_helpers" method="post">foo </form>
    HTML

    view.inferred_get_form.to_s.should contain <<-HTML
    <form action="/form_helpers" method="get">foo </form>
    HTML

    view.form_with_html_options.to_s.should contain <<-HTML
    <form action="/form_helpers" method="post" class="cool-form">foo </form>
    HTML

    form = view.form_for(FormHelpers::Index) { }
    form.to_s.should contain <<-HTML
    <form action="/form_helpers" method="get"></form>
    HTML

    form = view.form_for(FormHelpers::Index, class: "form-block") { }
    form.to_s.should contain <<-HTML
    <form action="/form_helpers" method="get" class="form-block"></form>
    HTML
  end
end

private def view
  TestPage.new
end
