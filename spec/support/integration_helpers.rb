module IntegrationHelpers
  def sign_in(user)
    visit new_user_session_path
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'password'
    click_button 'Sign in'
  end

  def select_date_and_time(date, options = {})
    field = options[:from]
    if field.kind_of?(Array) 
      field = field.join('_').to_sym
    end

    select date.strftime('%Y'), :from => "#{field}_1i" #year
    select date.strftime('%B'), :from => "#{field}_2i" #month
    select date.strftime('%-d'), :from => "#{field}_3i" #day 
    select date.strftime('%H'), :from => "#{field}_4i" #hour
    select date.strftime('%M'), :from => "#{field}_5i" #minute
  end

  def select_date(date, options = {})
    field = options[:from]
    select date.strftime('%Y'), :from => "#{field}_1i" #year
    select date.strftime('%B'), :from => "#{field}_2i" #month
    select date.strftime('%d'), :from => "#{field}_3i" #day 
  end
end
