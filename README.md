# StatisticsDashboard
# Dashboard Overview

# Author: Maisha Kasole

## Purpose of the Dashboard
The primary purpose of this dashboard is to teach and explore foundational properties of probability distributions. This application is designed for first-year undergraduate students as well as lifelong learners interested in visualizing and experimenting with the properties of common probability distributions. By selecting different distributions and adjusting their parameters, users can observe how the shapes and characteristics of these distributions change in real-time.

**The motivation** for creating this application stems from the challenges many learners face when encountering abstract statistical concepts. Visual aids are instrumental in bridging this gap by helping foster intuition and enhancing understanding of statistical concepts that may be unfamiliar or complex.

## User Engagement and Interactions
The dashboard is designed to be self-contained, providing all necessary information and functionality within the application. 

- The **Help tab**, positioned as the first tab, offers students clear instructions on how to use the dashboard and an introduction to probability distributions. 
- In the **Plot tab**, users can select different distribution types and adjust parameters via controls on the left side of the screen, with the plot updating in real time to reflect their changes. 
- The **Distribution Details tab** provides additional information that dynamically updates based on the selected distribution, offering users tailored insights into each type of distribution.
- Finally, the **Summary Statistics tab** generates and displays statistical summaries of the selected distribution, calculated based on the user-defined parameters and distribution type.

This structure ensures a comprehensive, interactive learning experience.

## Design Choices

### Visual and Thematic Design
The "Darkly" theme from the `shinythemes` package was chosen for its many attractive features:
- The dark background minimizes eye strain during prolonged use while providing strong contrast compared to other web pages that often use lighter themes.
- Tabs in use are highlighted in green, enhancing usability by making navigation clear and intuitive.
- Notably, "Darkly" was the only theme in the `shinythemes` library with this specific feature, making it the ideal choice for this application.

### Interactivity
Several key decisions were made to enhance user interaction with the application:
- **Real-time feedback**: Adjusting parameters instantly updates the plots, allowing users to immediately see the effects of their changes.
- **Tabbed layout**: The tabbed interface organizes information into distinct sections, making it easier for users to navigate and access specific content intuitively.
- **Dynamic parameter inputs**: The slider inputs are designed to accept only valid ranges for each parameter, ensuring that users can experiment without encountering errors.

## Desired Takeaway Messages
The desired takeaway messages are for users to gain insights into probability distributions by exploring how changing their parameters affects the distribution's shape and spread. It also introduces users to key mathematical concepts, such as the probability mass function (PMF) and probability density function (PDF), serving as a gateway to more advanced statistical topics.

## Application Link
You can access the application here: [Project 1 Dashboard](https://345naj-maisha-kasole.shinyapps.io/Project1Final/)
