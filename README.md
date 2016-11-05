# YPBT Web API
[ ![Codeship Status for ISS-SOA/ypbt-api](https://codeship.com/projects/c2f0d920-8535-0134-9419-0ea196d1355a/status?branch=master)](https://app.codeship.com/projects/182029)

API to access the information of comments following a given movie, such as author name, comment content, and author channel url.

## Routes

- `/` - check if API alive
- `/api/v0.1/video/video_id`                - confirm video id, get title of video
- `/api/v0.1/video/video_id/commentthreads` - get first three comments from the commentthreads of the video
