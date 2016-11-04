# YPBT Web API

API to access the information of comments following the movies, such as author name, comment content, and author channel url.

## Routes

- `/` - check if API alive
- `/api/v0.1/video/video_id`                - confirm video id, get title of video
- `/api/v0.1/video/video_id/commentthreads` - get first three comments from the commentthreads of the video
