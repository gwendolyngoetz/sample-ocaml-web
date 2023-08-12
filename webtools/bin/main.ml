open Tyxml.Html

let make_link url text = 
    a ~a:[a_href url; a_style "padding-right: 1rem;"]
        [txt text]

let header_nav =
  ul ~a:[a_class ["links_bar"]; a_id "links_bar"]
    [li ~a:[a_id "home_click"]
       [txt "My Musings"];
     li ~a:[a_id "about_click"]
       [txt "About Me"];
     li ~a:[a_id "blog_posts_click"]
       [txt "Blog"];
     li ~a:[a_id "hackathons_click"]
       [txt "Hackathons"]]


let layout pagetitle = 
    html
        (head (title (txt pagetitle)) [])
        (body [
            header_nav;
            h1 [
                txt "Hello!";
            ];
            h2 [txt "Header 2"];
            a ~a:[
                a_href "ocaml.org"; 
                a_class ["class123"]; 
                a_style "padding-right: 1rem;"
            ]
            [
                txt "OCaml!"
            ];
            make_link "/" "Homei";
            make_link "/page-1" "Page 1";
            make_link "/page-2" "Page 2";
        ])

let html_to_string html = 
    Format.asprintf "%a" (Tyxml.Html.pp ()) html

let () =
  Dream.run
  @@ Dream.logger
  @@ Dream_livereload.inject_script()
  @@ Dream.router [
    Dream.get "/" (fun _ ->
      Dream.html (html_to_string(layout "Home")));
    Dream.get "/page-1" (fun _ ->
      Dream.html (html_to_string(layout "Page 1")));
    Dream.get "/page-2" (fun _ ->
      Dream.html (html_to_string(layout "Page 2")));
    Dream_livereload.route()
  ]
