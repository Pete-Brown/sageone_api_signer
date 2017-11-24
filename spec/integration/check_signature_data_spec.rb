require 'rest-client'
require 'json'

RSpec.describe SageoneApiSigner do
  subject do
    SageoneApiSigner.new({
      request_method: 'post',
      url: 'https://api.sageone.com/test/accounts/v1/contacts?config_setting=foo',
      body_params: {
        'contact[contact_type_id]' => 1,
        'contact[name]' => 'My Customer'
      },
      signing_secret: 'TestSigningSecret',
      access_token: 'TestToken',
    })
  end

  describe 'doing a real call to the test endpoint' do
    it 'should check with the test server data' do
      headers = subject.request_headers('foo')

      begin
        RestClient.post subject.url, subject.body_params, headers
      rescue => e
        response =  JSON.parse(e.response.to_s)
        raise "#{response['error']}: #{response['error_description']}"
      end

    end
  end

  describe 'bug when the url has no params' do
    it 'should not raise an error!' do
      subject.url = 'https://api.sageone.com/test/accounts/v1/contacts'
      expect(subject.send(:signature_base).send(:url_params)).to eql({})
      expect(subject.signature).to_not be nil
    end
  end
end
