## Project Description
This project team is composed of Brian Austin, Liam Brown, Emma Reed,
and Patricia Thompson. We intend to create a web app named 
MelodyMatch. The intent of this application is to pair users into a
chat with another user based on music taste. Practically, this
means the application links to a user’s Spotify account to get an 
access token, uses the Spotify API to gather and store that user’s top
song information, then checks for other online users whose top songs 
list average above a configurable similarity threshold with the user. 
In addition to top song similarity comparison, the app also gets both 
users’ locations from the HTML location API to factor into the 
matching algorithm. 

When a user first registers for the service, they will give access to 
their top songs. From there, these songs will be individually queried 
to get their audio features. These include: danceability, energy, key,
loudness, mode, speechiness, acousticness, instrumentalness, liveness,
valence (how “happy” a song sounds), tempo, and type. These
features will be compiled into a database for later reference. The 
location of the user will also be stored.

When another user logs on or registers, their data will either be 
stored or retrieved and will be compared with those already logged on.
From there, the 12 audio features will be cross referenced to 
determine a match percentage. If this match percentage is over a 
certain threshold, then it will be considered a valid match. Once a 
match has been determined to be valid, the locations of the users will
be compared. If both users are within the radius selected by each
user upon every login, then they will be considered a match. For 
example, if a user logs in and selects a radius of 100 miles and there
is a user already in the lobby that has a match percentage with the 
user of 70%, then they will be considered a potential match. 
Once their locations are compared, if the distance is within the 
selected range of both users, they will be considered a valid match.

Once a match is found, both users are added to a chat where they can 
send messages back and forth. Once they are finished with the chat, 
they can return to the home screen where the email addresses, 
gathered upon sign-up, of all their previous matches will be listed, 
and the app will go back to searching for a new chat partner for them. 

The real-time behavior this application intends to use will be within 
the chat function. As soon as possible after one user sends a message,
both users should see the sent message appear within the chat window 
for ease of use and to simplify conversational flow. While logging in 
will cause the app to re-scrape a user’s top song information from
the Spotify API, for simplicity of the app, a user’s song data will 
be stored in the postgres database. The persistent state stored in 
the postgres database will be composed of the user’s login 
information: name, email, password hash, and spotify authentication 
tokens. It will also contain a table of all previous matches between 
users. This will allow for the intended behavior of being able to show
a user the email address of their previous matches so they can reach 
out to that user specifically at a later point in time. 

The `something neat` of this project will be the incorporation of the 
HTML location API. The intent here is to include a user’s physical 
location as one of the factors in determining match compatibility. 
While one can share music tastes with people all over the world, it 
would be nice to be more likely to match with a user in your area for 
two reasons. The first is that if you ever wanted to meet your match 
in person, filtering by location proximity dramatically simplifies 
that. The second is that, presumably, if you match well with someone, 
you may wish to be able to speak with them again, and ensuring they 
are in at least a similar time zone helps ensure this.

## Experiments
In order to prepare for this project, the team did two experiments to 
test the viability of creating an application for this course that 
could correctly integrate with the Spotify API.

### Experiment 1: Backend
The first experiment focused on the backend integration with the API. 
The team was concerned about creating an elixir backend that could 
correctly send and get information from an external API, so this 
experiment was intended to be just that: create a solely elixir-based 
app that could ask a user to link their spotify information, 
integrate that token into an API request, send a request for the 
user’s top song titles, then on callback, link the user to another 
elixir page that displayed their top song requests.

This experiment was a success. Simple elixir code to allow a user to 
link their Spotify account was generated for development simplicity, 
though that will likely not be used in the final React-based front 
end of the application. Upon linking the user’s Spotify account, the 
elixir code correctly gathered the user token needed to gather 
information on that specific user. Backend elixir code was created 
that correctly incorporated both the developer information that 
allows permission to request from the Spotify API in general, as well 
as including the user token that allows the application to request 
information about a specific user from the Spotify API. That 
successful request was then able to be accessed by the elixir 
application in general, allowing it to be able to be passed back up to
the front end of the application. In addition to all of this, elixir 
code to refresh expiring user access tokens as needed was created. 
This code uses the existing refresh token the application has for a 
user to ask the Spotify API for a newer one, ensuring that the 
application can continue to request data about that user from the 
Spotify API when needed. This is important because a user’s top songs 
may change over time, so the application needs to retain the ability 
to get the most up-to-date information about a user’s top songs.

Additionally, on top of all the backend code functionality, this 
experiment generated the infrastructure for the elixir application to 
keep its development secrets within a local environment file instead 
of within the application itself, allowing for both security and 
simplicity of later development steps.

From this experiment, the team learned the correct structuring of API 
requests to the Spotify API. This means that the correctly formatted 
inclusion of developer and user information together was used to be 
able to gather the corresponding API information. The team also 
learned about the necessity of refreshing user access tokens as 
needed. Spotify tokens have an expiration time, so ensuring that the 
application requests a new refresh token with the old one before the 
old one expires is critical to the smooth running of the application. 
Also discerned from this experiment was the fact that storing user 
tokens within the postgres database, even if they need to be 
overwritten on occasion, is the simplest and cleanest way to store 
that information for the user. Finally, this experiment assisted with 
the debugging of generating some custom config setups for the 
application that varied slightly from the previous config files we 
had developed for class projects.

### Experiment 2: Frontend
Our second experiment focuses on making a seamless user experience
for the registration process. While we did not include passwords in 
this experiment because those add additional complexity, we wanted to 
test our ability to integrate the spotify OAuth workflow into a 
registration form. We choose this experience, because we were 
concerned with being able to integrate the outside authentication 
workflow without making it confusing to the user. We decided to test 
this by creating a basic registration experience with the spotify 
oauth popout. To confirm that we correctly completed the auth 
process, we fetched the top 10 tracks of a user once they completed 
the registration workflow.

This experiment validated the feasibility of the idea. We were able to
complete the expected experiment successfully. We were able to create 
a react app that would allow a user to login into spotify, retrieve 
the oauth code, enter a username and password, and find their top 10 
tracks. This experiment also allowed us to become familiar with the 
data retrieved from the Spotify API. For example, spotify will return 
a list of artists in order to account for collaborations and other 
works with multiple artists. This required more complex formatting 
functions to make sure that all artists were shown. In addition, 
fetching the album art required understanding of the formatting in 
which Spotify gives images.

From this experiment, we learned that the Spotify OAuth process can 
be integrated into an internal registration process without ruining 
the user experience. We were able to confirm that the app can still be
easy to use, even with the external authentication requirements. We 
were also able to get the basics of a react app set up in ways that 
allowed for conditional and reactive formatting based on what steps 
the user had already completed. From these learnings, we were able to 
prove the concept of our front end application.

## User Stories
This application only really has a single type of user. There’s not a 
system administrator who can remove users or see everyone’s matches 
(however, administration may be done at the database level if 
information needs to be redacted per CCPA, GDPR, or other relevant 
privacy-focused legislation). 

The single type of user is a standard one: one who is intending to 
sign in to the application and hopefully find a chat match.

For a standard user, the most common workflow goes as follows. If the 
user is not signed up, they may register with the application, giving 
name, email address, password, and any other applicable information. 
After submitting, they will be asked to link their Spotify account 
with the MelodyMatch application. If, instead, they have previously 
registered, they log in. Because of the refresh tokens functionality 
on the backend, the user logging in to an old account does not have 
to relink their Spotify account to MelodyMatch. 

When a user logs in or completes registration, the application will 
automatically fetch or refresh their Spotify results and give users 
the option to refresh their location and select a radius for matching.
A radius of 100 miles will be used if they choose not to refresh any 
of this information. Once a user has allowed this refresh to happen 
and confirmed a radius, they will be taken to a home page. 

Upon login or after linking the user’s Spotify account, the user is 
taken to a home page. This page displays a listing of any previous 
matches the user has had on the application, as well as any other 
information they might find helpful. For example, this page may also 
display the top songs for the user that the application is using to 
match them with others. The logout button is also found here on the 
homepage, allowing the user to sign out of the application. Finally, 
the home page also contains a `Find Matches` button that, once 
selected, will add the user into the queue of users currently looking 
for chat partners. Once selected, the page will display a wait 
message, informing the user that the application is looking for a 
suitable partner. The user will remain an indeterminate amount of time
on this home page after selecting the `Find Matches` button. 

Once a chat partner is found, the user is moved from the homepage to a
chat page. This chat page lists a little bit of information about the 
user’s chat partner, including their email address. It also has a text
box and send button that allows the user to send chats. In addition to
a typing area, the chat has a chat feed that displays messages from 
both chat partners in the order received by the server. These messages
are clearly discernible about which user sent them. The final main 
component of the chat screen is a back function. This allows a user to
leave the chat and return to the home page.

Upon return to the home page, the user may opt to select nothing and 
simply remain on the home page, logout, or select the `Find Matches` 
to receive a new match to someone not currently in a chat. The 
algorithm will not re-match a user with their most recent chat partner
or partners within a configurable timeframe, allowing for a user to 
have more diversity of chat matches even if one singular other user is
a particularly strong match. Upon leaving a chat, the list of previous
matches the user has had will be updated to include their most recent 
chat partner.
