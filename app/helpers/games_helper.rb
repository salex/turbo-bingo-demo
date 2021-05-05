module GamesHelper

  def recent_calls(calls)
    html = "&nbsp;".html_safe;
    calls.slice(0,8).each do |c|
      color = "#{c[0..0].downcase}ltr"
      html << content_tag( :span, c, class: "r-calls #{color}")
    end
    return html.html_safe
  end

  def curr_call(calls)
    c = calls[0]
    html = "&nbsp;".html_safe
    if  c.present?
      color = "bkg-#{c[0..0].downcase}ltr"
      html = content_tag( :div, c[1..-1], class: "#{color}")
    end
  end

  def pattern_row(r)
    trow = ""
    r.each_char do |c|
      if c == 'x'
        trow <<  content_tag(:td,'X', class: "white")
      else
        trow << content_tag(:td,'&nbsp'.html_safe)
      end
    end
    trow.html_safe
  end

  def game_pattern(game)
    p = Game::Patterns[game.pattern]
    return '<tr><th colspan="5">Game Pattern not set</th></tr>'.html_safe if p.blank?
    rows = ""
    p.each do |row|
      rows << content_tag(:tr,pattern_row(row))
    end
    rows.html_safe
  end


  def pattern_rows(str)
    # p "STR #{str}"
    pat = pattern_to_rows(str)
    # p "PAT #{pat}"
    rows = ""
    pat.each_with_index do |row,i|
      rows << content_tag(:tr,pattern_tr(row),class:"pattern-tr",data:{behavior:'toggle_td'})
    end
    rows.html_safe
  end

  def pattern_tr(arr)
    trow = ""
    arr.each do |c|
      if %{x X}.include?(c)
        trow <<  content_tag(:td,'X', class: "color-white")
      else
        trow << content_tag(:td,'.', class:'color-black')
      end
    end
    trow.html_safe
  end

  def pattern_to_rows(pattern)
    if pattern.blank?
      pattern = '.........................'
    end
    # p "PATTERN #{pattern}"
    # pattern is a 25 character string with space or x
    cols = [[],[],[],[],[]]
    # split pattern into 5 columns
    pattern.each_char.with_index do |c,i|
      cols[i%5] << c
    end
    # transpose the columns into rows
    # p "COLS  #{cols}"

    cols.transpose
  end


end
