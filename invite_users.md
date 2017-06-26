Invite Users

landing page where you can enter name/email/invite message to friend
  -on submit it sends email to their email
  -email contains link to register page
    -register page has email addy prefilled
  -on signup
    -creates user
    -creates following both ways between sign up and friend that invited them

- use tests for controller/model/integration
- 
invitation controller
  new for form to send email to friend
  create to actually send email
  when link clicked in email send email as param
    in view have email = params[:email] if it exists
  on signup - need to have indicator that relationshipo needs to be created
    need to have matching one for referrer