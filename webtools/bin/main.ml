open Tyxml.Html

let make_link url text = 
    a ~a:[a_href url;]
        [txt text]

let header_nav =
    header [
      nav [
        ul ~a:[a_class ["links_bar"]; a_id "links_bar"] [
           li ~a:[a_id "home_click"]
              [make_link "/" "Home"];
           li ~a:[a_id "about_click"]
              [make_link "/page-1" "Page-1"];
           li ~a:[a_id "blog_posts_click"]
              [make_link "/page-2" "Page-2"];
        ]
      ]
    ]


let layout_full pagetitle = 
    html
        (head (
            title (txt pagetitle)) [
            link ~rel:[`Icon] ~href:"/assets/img/favicon-32x32.png" ();
            link ~rel:[`Stylesheet] ~href:"/assets/css/main.css" ();
        ])
        (body [
            header_nav;
            main [
              h1 [txt pagetitle];
              p [txt "Lipsum";];
            ]
        ])

let layout pagetitle page_content = 
    html
        (head (
            title (txt pagetitle)) [
            link ~rel:[`Icon] ~href:"/assets/img/favicon-32x32.png" ();
            link ~rel:[`Stylesheet] ~href:"/assets/css/main.css" ();
            script ~a:[a_src (Xml.uri_of_string "https://unpkg.com/htmx.org@1.9.4")] (txt "")
        ])
        (body [
            header_nav;
            main [
              h1 [txt pagetitle];
              p [txt "Lipsum";];
              page_content;
              div [
                  button ~a:[
                    Unsafe.string_attrib "hx-post" "/fragment-1";
                    Unsafe.string_attrib "hx-trigger" "click";
                    Unsafe.string_attrib "hx-swap" "innerHTML";
                    Unsafe.string_attrib "hx-target" "#swap-target";
                  ] 
                  [txt "show fragment-1"];
                  button ~a:[
                    Unsafe.string_attrib "hx-post" "/fragment-2";
                    Unsafe.string_attrib "hx-trigger" "click";
                    Unsafe.string_attrib "hx-swap" "innerHTML";
                    Unsafe.string_attrib "hx-target" "#swap-target";
                  ] 
                  [txt "show fragment-2"];
              ];
              div ~a:[a_id "swap-target"][]
            ]
        ])

let html_fragment fragment_text =
    div ~a:[a_class ["div123"]] [ 
        h1 [ txt fragment_text ] 
    ]

let page2_content = make_link "zzz" "ixxx"

let html_to_string html = 
    Format.asprintf "%a" (Tyxml.Html.pp ()) html

let html_fragment_to_string html = 
    Format.asprintf "%a" (Tyxml.Html.pp_elt ()) html

let () =
    Dream.run ~interface: "0.0.0.0"
  @@ Dream.logger
  @@ Dream.router [
    Dream.get "/" (fun _ ->
      Dream.html (html_to_string(layout_full "Home")));

    Dream.get "/page-1" (fun _ ->
      Dream.html (html_to_string(layout_full "Page 1")));

    Dream.get "/page-2" (fun _ ->
      Dream.html (html_to_string(layout "Page 2" page2_content)));

    Dream.post "/fragment-1" (fun _ ->
      Dream.html (html_fragment_to_string(html_fragment "fragment 1")));

    Dream.post "/fragment-2" (fun _ ->
      Dream.html (html_fragment_to_string(html_fragment "fragment 2")));

    Dream.get "/assets/**" @@ Dream.static "assets";

    Dream_livereload.route();
  ]
