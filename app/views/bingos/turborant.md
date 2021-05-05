
I'm about to give up on Turbo, at least streaming. Stimulus took a little while to get the hang of, but you had a handbook the explained just about everything - you just had to absorb it. If you look at the few Rails demos using Turbo there's not much in the handbook that looks the same (turbo handbook is generic html - not Rails). There is also not much documentation for the hotwire-rails gem unless you can read/understand the documented code. I guess I'm not absorbing Turbo yet and I probably don't need it - but I keep trying. I dusted off an old rails demo app I toyed with that was jQuey/coffee script based and tried to replicate it using Turbo.

- I have a simple model `Bingo` that only has a few attributes.
- The controller only has 3 actions and associated views :show, :edit, :update
- The show view is more or less a status view of the current game.
  - A board displaying what numbers have been called
  - Some stats on last and recent calls
- The edit view is almost the same as the show view but responds to clicks that trigger an update action
  - Clicking on one of the 75 numbers will add or remove that number from the calls (attribute - serialized array)
  - Clicking on a button in the button bar will trigger an update (patch form) that will change game state


My goal was to stream any changes made to the current game to anyone viewing the show view. I actually got it to semi-work trying various schemes I've seen in the chat demos.

```ruby
class Bingo < Game
  broadcasts
end
```

```slim
// _bingo.html.slim rendered from show.html.slim
#header.w3-white MY PROBLEM
= turbo_stream_from bingo
= turbo_frame_tag dom_id(bingo) do
  #display.w3-row
    #game-status = [nil,"Resume","New","Current","current"].include?(bingo.state) ? nil : bingo.state
    - [['B',1],['I',16],['N',31],['G',46],['O',61]].each do |r|
      - c = r[0].downcase
      .square class="#{c}ltr npoint" = r[0]
      - r[1].upto(r[1] + 14) do |i|
        - id = "#{r[0]}#{i}"
        - if bingo.calls.include?(id)
          .square.num-on[id="#{id}" class="num-on#{c}"] = i
        - else
          .square.num-off[id="#{id}" class="num-off#{c}"] = i
  = render partial: 'bingos/status', locals: {bingo: bingo}

```

```slim
// _edit.html.slim rendered from edit.html.slim
= turbo_frame_tag dom_id(@bingo,:caller) do
  #display.w3-row[data-controller="callerBoard"]
    #game-status = [nil,"Resume","New","Current","current"].include?(@bingo.state) ? nil : @bingo.state
    - [['B',1],['I',16],['N',31],['G',46],['O',61]].each do |r|
      - c = r[0].downcase
      .square class="#{c}ltr npoint" = r[0]
      - r[1].upto(r[1] + 14) do |i|
        - id = "#{r[0]}#{i}"
        - if @bingo.calls.include?(id)
          .square.num-on(id="#{id}" data-callerBoard-target="toggle" data-action="click->callerBoard#clear" class="num-on#{c}") = i
        - else
          .square.num-off(id="#{id}" data-callerBoard-target="toggle" data-action="click->callerBoard#call" class="num-off#{c}") = i
    = render partial: 'status', locals: {bingo: @bingo}
    = render partial:"button_bar", locals:{bingo: @bingo}
```

The semi-works comment is that it appears to append the turbo-frame tag. The `#header.w3-white MY PROBLEM` outside the frame (added to debug) will double on every change and the html will scroll down. I've tried replacing the `broadcasts` in the model wih:

`broadcast_replace_to target:"bingo_#{self.id}", partial: 'bingos/bingo', locals:{bingo:self}` 

on a after commit action and nothing happens. I can seen the html render in console, but the show view does not change. I also tried a couple respond_to.turbo_stream approaches and they also did not work.

I posted something similar a few weeks ago but was probably too vague and received zero response. Being able to stream from the model, or the controller and maybe from the turbo_stream_tag probably got me mixing apples and oranges. I have tried adding numerous stuff to the tags, tried what little I could find on `broadcast_tos` but the only thing that seems to semi-work is the `broadcasts`.  







About four years ago I had a brain fart after a non-profit organization that I was part of looked into starting a Bingo operation. After looking at the startup costs ($2k to $5k for caller boards and other stuff), we decided against it. But not before I threw up a prototype Rail app that used Raspberry Pi's to drive TV's as caller boards and the controller (caller).

Now I have no use for a Chat/Twitter like app in the few semi-private Rails apps I have deployed. I thought I'd look at Turbo just as a learning experience. I've now proved to myself that I know less than I though!

I tried to port my Bingo Controller/Viewer app (jQuery/coffee) over to Turbo as just a learning experience. I've now spent many hours trying to get something working without understanding the core principles.

I got it to react as I conceived, but not work. I can bring up the controller (edit) and broadcast to the viewer(s) (show), but after 9 updates (bingo calls), the viewer goes blank (target replaced with nil)! I'm sure it's my code, but I have no idea on what I'm doing and what I did wrong!

I'll try to be brief. This is the Caller's board view (edit action)

image

The Viewer board (show action) is about the same, except it does not respond to clicks and does not have action buttons to change state. Viewer boards can be on a TV or phone/pad. When the caller gets a call from  whatever the thing is that pops up balls, they click on the number and see if anyone shouts BINGO, etc, etc. The viewer board is just an aid to the players if they want to confirm the call. I had thoughts of using Raspberry inputs to trigger the calls but never got that far.

Unlike the Chat app demos there is only one model here and three actions (show edit update). Game is the base model and only has three attributes: Calls - a serialized array of numbers (1..75), Status - (current, won) and State - (nil, break, bingo). State is controlled by the button bar, calls controlled by clicks on numbers/calls (or mistakes, clicked wrong number and removed before SHOUTING B 10). I inherited the Game model as Bingo and added a route `resource :bingo, only: [:show, :edit, :update]`

The Bingo model

```ruby
class Bingo < Game
  broadcasts

  def self.current
    self.find_by(status:'current')
  end

  # def viewer #(a failed attempt)
  #   self.broadcast_replace_to target:"bingo_#{self.id}", partial: 'bingos/bingo', locals:{bingo:self}
  # end
end
```
The bingo controller

```ruby
class BingosController < ApplicationController
  before_action :set_bingo, only: %i[ show edit update]

  def show
  end

  def edit
  end

  def update
    if params[:bingo][:calls].present?
      add,call = params[:bingo][:calls].split
      if add == 'add'
        @bingo.calls.unshift(call)
      else
        @bingo.calls.delete(call)
      end
    end
    if params[:bingo][:control].present?
      @bingo.state = params[:bingo][:control]
    end
    @bingo.save
    # @bingo.viewer (the failed attempt at braodcast_to)
    render action: :edit
  end
 
  private
   ... standard stuff
end
```

Note there is no `respond_to` stuff, that didn't seem to work.

The views (I use slim so #'s' are not all comments `# ` are)

```ruby
# bingos/show.html.slim
= render @bingo, bingo: @bingo

# bingos/_bingo.html.slim
#container
  hr.w3-white
  = turbo_stream_from bingo
  = turbo_frame_tag dom_id(bingo) do
    #display.w3-row
      #game-status = [nil,"Resume","New","Current","current"].include?(bingo.state) ? nil : bingo.state
      - [['B',1],['I',16],['N',31],['G',46],['O',61]].each do |r|
        - c = r[0].downcase
        .square class="#{c}ltr npoint" = r[0]
        - r[1].upto(r[1] + 14) do |i|
          - id = "#{r[0]}#{i}"
          - if bingo.calls.include?(id)
            .square.num-on[id="#{id}" class="num-on#{c}"] = i
          - else
            .square.num-off[id="#{id}" class="num-off#{c}"] = i
    = render partial: 'bingos/status', locals: {bingo: bingo}

# bingos/edit.html.slim
 = render partial:'edit', locals:{bingo: @bingo}

# bingos/_edit.html.slim
#container
  = turbo_frame_tag dom_id(@bingo,:caller) do
    #display.w3-row[data-controller="callerBoard"]
      #game-status = [nil,"Resume","New","Current","current"].include?(@bingo.state) ? nil : @bingo.state
      - [['B',1],['I',16],['N',31],['G',46],['O',61]].each do |r|
        - c = r[0].downcase
        .square class="#{c}ltr npoint" = r[0]
        - r[1].upto(r[1] + 14) do |i|
          - id = "#{r[0]}#{i}"
          - if @bingo.calls.include?(id)
            .square.num-on(id="#{id}" data-callerBoard-target="toggle" data-action="click->callerBoard#clear" class="num-on#{c}") = i
          - else
            .square.num-off(id="#{id}" data-callerBoard-target="toggle" data-action="click->callerBoard#call" class="num-off#{c}") = i
      = render partial: 'status', locals: {bingo: @bingo}
      = render partial:"button_bar", locals:{bingo: @bingo}
  ```

If in the viewer's view I changed the dom_id to to `dom_id(bingo, :viewer)` but it didn't work. I can see in the console that the target is `viewer_bingo_2` but the viewer does not respond to changes.

It's clear I'm missing some core concepts. Works great for about 6 calls, then the 7th there is a little hesitation, a little more with 8, then 9 give me a blank screen.

I'll point out that I'm on OSX and had to run that Docker kludge. That could be the problem, but I doubt it.

All I wanted to do is have a Show page respond to changes submitted by the Edit update. Maybe you can't do that?

<div id="container">
  <div class="w3-text-white" id="header">Hi Viewer</div>
  <turbo-cable-stream-source channel="Turbo::StreamsChannel" signed-stream-name="IloybGtPaTh2WW1sdVoyOHRaR1Z0Ynk5Q2FXNW5ieTh5Ig==--daff349a1b6f4e2a94a7cbb9323971d72e6070fa335d4e22845974887a3713ea"></turbo-cable-stream-source>
  <turbo-cable-stream-source channel="Turbo::StreamsChannel" signed-stream-name="IloybGtPaTh2WW1sdVoyOHRaR1Z0Ynk5Q2FXNW5ieTh5Ig==--daff349a1b6f4e2a94a7cbb9323971d72e6070fa335d4e22845974887a3713ea"></turbo-cable-stream-source>
  <turbo-cable-stream-source channel="Turbo::StreamsChannel" signed-stream-name="IloybGtPaTh2WW1sdVoyOHRaR1Z0Ynk5Q2FXNW5ieTh5Ig==--daff349a1b6f4e2a94a7cbb9323971d72e6070fa335d4e22845974887a3713ea"></turbo-cable-stream-source>
  <turbo-cable-stream-source channel="Turbo::StreamsChannel" signed-stream-name="IloybGtPaTh2WW1sdVoyOHRaR1Z0Ynk5Q2FXNW5ieTh5Ig==--daff349a1b6f4e2a94a7cbb9323971d72e6070fa335d4e22845974887a3713ea"></turbo-cable-stream-source>
  <turbo-frame id="bingo_2">
    payload html
  </turbo-frame>
</div>




