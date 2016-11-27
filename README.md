# YPBT Web API
[ ![Codeship Status for ISS-SOA/ypbt-api](https://codeship.com/projects/c2f0d920-8535-0134-9419-0ea196d1355a/status?branch=master)](https://app.codeship.com/projects/182029)

API to access the information of comments following a given movie, such as author name, comment content, and author channel url.

# YTBT-API doc

## Video  
* <strong>Get</strong> /api/{version}/video/{video id}  

> *Discription:* return a basic information of targe video   
> *Return:*  
<table>
<tr><td><strong>Field</strong></td><td><strong>Type</strong></td></tr>
<tr><td>video_id</td><td>string</td></tr>
<tr><td>title</td><td>string</td></tr>
<tr><td>description</td><td>string</td></tr>
<tr><td>view_count</td><td>int</td></tr>
<tr><td>like_count</td><td>int</td></tr>
<tr><td>dislike_count</td><td>int</td></tr>
</table>

## Comment
* <strong>Get</strong> /api/{version}/Comment/{comment id}  
> *Discription:* return the detail information of targe comment    
> *Return:*
<table>
<tr><td><strong>Field</strong></td><td><strong>Type</strong></td></tr>
<tr><td>video_id</td><td>string</td></tr>
<tr><td>comment_id</td><td>string</td></tr>
<tr><td>text_display</td><td>string</td></tr>
<tr><td>like_count</td><td>int</td></tr>
<tr><td>author_name</td><td>string</td></tr>
<tr><td>author_image_url</td><td>url</td></tr>
<tr><td>author_channel_url</td><td>url</td></tr>
</table>

* <strong>Get</strong> /api/{version}/Comments/{video id}  
> *Discription:* return the detail information of comments  
> *Return:* array of <strong>comment datas</strong>  
> <strong>comment data=</strong>
<table>
<tr><td><strong>Field</strong></td><td><strong>Type</strong></td></tr>
<tr><td>video_id</td><td>string</td></tr>
<tr><td>comment_id</td><td>string</td></tr>
<tr><td>text_display</td><td>string</td></tr>
<tr><td>like_count</td><td>int</td></tr>
<tr><td>author_name</td><td>string</td></tr>
<tr><td>author_image_url</td><td>url</td></tr>
<tr><td>author_channel_url</td><td>url</td></tr>
</table>

## Time Tag
* <strong>Get</strong> /api/{version}/TimeTag/{video id}  
> *Discription:* return raw data of time tags that belong to target video  
> *Return:*  array of <strong>time tags info</strong>  
> <strong>time tags info=</strong>
<table>
<tr><td><strong>Field</strong></td><td><strong>Type</strong></td></tr>
<tr><td>time_tag_id</td><td>string</td></tr>
<tr><td>start_time</td><td>string</td></tr>
<tr><td>end_time</td><td>string</td></tr>
<tr><td>tag_type</td><td>string</td></tr>
<tr><td>start_time_percentage</td><td>float</td></tr>
<tr><td>end_time_percentage</td><td>float</td></tr>
</table>

* <strong>Get</strong> /api/{version}/TimeTag/{time_tag_id}
> *Discription:* return detail data of target time tag  
> *Return:*  
<table>
<tr><td><strong>Field</strong></td><td><strong>Type</strong></td></tr>
<tr><td>time_tag_id</td><td>string</td></tr>
<tr><td>start_time</td><td>string</td></tr>
<tr><td>end_time</td><td>string</td></tr>
<tr><td>like_count</td><td>int</td></tr>
<tr><td>tag_type</td><td>string</td></tr>
<tr><td>comment_text_display</td><td>string</td></tr>
<tr><td>comment_author_name</td><td>string</td></tr>
<tr><td>comment_author_image_url</td><td>url</td></tr>
<tr><td>comment_author_channel_url</td><td>url</td></tr>
</table>  

* <strong>Post</strong> /api/{version}/TimeTag/
> *Discription:* add new TimeTag    
> *Parameter:*
<table>
<tr><td><strong>Field</strong></td><td><strong>Type</strong></td></tr>
<tr><td>video_id</td><td>string</td></tr>
<tr><td>start_time</td><td>string</td></tr>
<tr><td>end_time (optional)</td><td>string</td></tr>
<tr><td>tag_type</td><td>string</td></tr>
<tr><td>comment_text_display</td><td>string</td></tr>
</table>

* <strong>Put</strong> /api/{version}/TimeTag/
> *Discription:* add like count for the tag  
> *Parameter:*
<table>
<tr><td><strong>Field</strong></td><td><strong>Type</strong></td></tr>
<tr><td>time_tag_id</td><td>string</td></tr>
</table>
