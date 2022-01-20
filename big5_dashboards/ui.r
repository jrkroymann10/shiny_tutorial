shinyUI(
  fluidPage(
    navbarPage(
      "Big 5 Dashboards by Joe",
      
      # Intro Tab -----
      tabPanel(
        "Introduction",
        
        titlePanel("Welcome to Joe's Premier League Dashboards!")
      ),
      
      # Standings Tab (bump, regular) ----
      navbarMenu(
        "League Table",
        tabPanel(
          "Standard Table"
        ),
        tabPanel(
          "Interactive Bump Plot",
          titlePanel("View your team's journey up and down the table!"),
          
          p("Hover over a team's name to view their path, or select a team in the sidebar for a smoother, detailed view"),
          
          sidebarLayout(
            sidebarPanel( 
              sliderInput(
                inputId = "md_range",
                label = "Matchday Range",
                value = c(1, tail(big5_match_data[big5_match_data$Competition_Name == "Bundesliga" & !is.na(big5_match_data$Home_xG),]$Wk, 1)),
                min = 1,
                max = tail(big5_match_data[big5_match_data$Competition_Name == "Bundesliga" & !is.na(big5_match_data$Home_xG),]$Wk, 1),
                round = TRUE,
                step = 1,
                width = 300),
              selectizeInput(
                "Competition",
                "Competition",
                choices = c("Bundesliga", "La Liga", "Ligue 1", "Premier League",
                            "Serie A"),
                multiple = FALSE,
                options = list(
                  placeholder = 'Select a Competition',
                  onInitialize = I('function() { this.setValue("Bundesliga"); }')
                ),
                width = 300),
              selectizeInput(
                "Teams",
                "Teams",
                choices = pl_teams,
                multiple = TRUE,
                options = list(
                  placeholder = 'Select team(s) below',
                  onInitialize = I('function() { this.setValue(""); }')
                ),
                width = 300),
              selectizeInput(
                "back_color",
                "Plot Background Color",
                choices = c("#D3D3D3 (Gray)",
                            "#000000 (Black)"),
                options = list(
                  placeholder = 'Select a Background Color',
                  onInitialize = I('function() { this.setValue("#D3D3D3 (Gray)"); }')
                ),
                width = 300),
              checkboxInput(
                inputId = "bumpRank",
                label = "See Weekly Ranks of Selected Team(s)",
                value = FALSE),
              fluidRow(
                column(
                  width = 6,
                  align = "center",
                  actionButton(inputId = "resetBumpTeams", "Reset Team Input(s)", width = 150)),
                column(
                  width = 6,
                  align = "center",
                  actionButton(inputId = "resetBumpRange", "Reset MD Range", width = 150))
              ),
              
              width = 3),
            mainPanel(girafeOutput(outputId = "bumpPlot"))
            ),
          br()
        )
      ),
      # GK Zone Tab ----
      tabPanel(
        "GK Zone",
        
        titlePanel("Pick the Visualization you'd like to view (Or the one the makes you feel best about your team's keeper)"),
        br(),
        fluidRow(
          column(3,
                 selectInput(inputId = "gk_viz",
                             label = "Select a Viz",
                             choices = c("Who's Beating the Model?", "Getting Out of the Box", "Are Crosses Scary?",
                                         "Building From the Back"),
                             selected = "Who's Beating the Model?"
                             ),
                 selectInput(inputId = "gk_highlight",
                             label = "Highlight a Goalkeeper",
                             choices = pl_gks$Player,
                             selected = NULL),
                 textOutput("gk_text"),
                 ),
          column(9,
                 girafeOutput("gkPlot")
                 )
          ),
        br()
      )
    )
  )
)