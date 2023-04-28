require 'fcm'

class TestFcm
  def initialize
    @fcm = FCM.new(
      'AAAAo7tozFs:APA91bHvJ0s-5rHP9ptt97op9DEp9wCKXKDee9q0Vas1oyZ-SSFS6Mo37-gsULk_m2IVWe5dUVDXlpf-wLJuEsqxhrhXcXdPcU-t33wNBuAYJWdeMsmUvOWUs31ReCybSNsN489CWh_T',
      '/Users/maciejciepluch/Downloads/carbonless.json',
#       StringIO.new(ENV.fetch('{
#   "type": "service_account",
#   "project_id": "carbonless-6e60d",
#   "private_key_id": "2fc1b7195ad6ce39fd91c3f8538fc9e81735854a",
#   "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDihkDEG1BuTqjf\numt/LSc5nInbg613KXfbDGpkdVSDm+fjD3btF6paPPZzqn17BVLETkRHCZR1bJ2O\nUn1YYoh+6fuFUGQgG6TzMBDTtZtYKn0FnbeG1SxBtaoO7J1X/CV4CMp2AGywG4jD\nq1MClMROolLX2TJHvIKv8/2xb1TZWQG5FteiCpjsmhuwTZvlZ/VCVdOYj8rK+Agn\nF174PlRrPOH+8mMtgnwQzdNfTnwiriBXQdCeBhpXpk6BPX7YnIpFLScdwQlFHegX\nQpmpvkExe4zBxkgIdYsMMLLGh6T/TW6XTshrFKpu9Uo/NhjSjSKKETmEGe88Ulsc\nvdcuGl09AgMBAAECggEAYEqGbHZZ7dH1GkmB2YlFo8lFlrD2Q3G2t8Ai17pCZ0GW\nRGB2Atns+bfxYYCnH2zHXpgQkQvi9jlqDi5FhxU3hY+L8gMW1Mk7iH61oHER7Fv/\nUixVb/Tc/7+r3vU4+0Y9XTWLbrbGfOPvcpG40x+PBQgeZA+5PmJFQWtbu5miPVM6\nTnddC2jGhEKwgDvVXaQV8NIusB8XNr6Wn+eyNu9JUVaJ2GJvY/tdQYybpa3OZ/aZ\nnxB+VoPr6a1q7iN80r79LM3crAkuc6U0VkegdWyGFB8HNAa3iDgKtX6SNyU1ZSu7\nOvaf8+hHZC/e+7vxUkyE6USFbjJNnUL+eeUsUY655wKBgQD2OnlmHBPUV2KkDFVW\nRd92mqmf6u8sx+VCaCrpACoxFHWdUfyhsBp0EO+Fzb0O5OjhrhxwKgbeF8v+vV5I\n4E6kw47Tj+ahaNT+UCHiApT/HT7D5jLuQpFtPWWiqEHo0LBz46+uS0NjpigluART\nKqF0z4PzGv/nGedsa8Alrc2dtwKBgQDrg5lAxrMYETqaY/ohwx6CXkkrMsTARW5Z\nfcl4snOMVbDXEQBTWQTeC+qykyF0UbTkQm+p96d99OIq3W/yeh0vTYh/V5BrD1kq\nJPgfGduGnbevEUT1+lRBCzcAywlVXmamBBINPZfgnjvujvNsFe1ZYdNCRyisDEQS\nwXrUy44cqwKBgE833ujwLZ0KhEzdPvNjxZJmDh7KOisBIQxtcSjHicuClpiH0Sy/\n+LLQ5A77c1EAasB5AONBUjZQF6ychmIR8Jtn42LDkGLr1GMBqvUI+aDeatwiCs7H\nEfzAXRuo4JOj2LFgVpxP0J2VzqLcAmAzfgCT5xLm4+AZYHBsdkRpF5cfAoGAcbV2\nFtpYufQHkWdX61kjr9oKBbtbV2GuZ7LdxVKTi1wMJ6pjt9oxCWxDgria3GheqB6T\nf0K9MYk8cWm8lRv0X1RV5PXIGoisijaTPaDkZthbSUFTRFf6ufTKN63P8dHESb+J\nX68vVxnO4d1PFg54LEGZGFT3BCpf65ZS0c797EUCgYBwxyg/D9Sd1N9GjZBroRLt\nMlJ1oAzkWdZLQByEPSeHRya9zAuumlXho9tFNTz5lB6peoqzOQI002b8KeOiawwL\n6kuivbO94W/81zjlK0/TCHxIaMxTyA4govcoH+JllrU/soY8Tws0xbv0tV21YWcD\ntEl/K0YuhS+U1eeDuiyqJQ==\n-----END PRIVATE KEY-----\n",
#   "client_email": "firebase-adminsdk-ukxfh@carbonless-6e60d.iam.gserviceaccount.com",
#   "client_id": "100763109151682652715",
#   "auth_uri": "https://accounts.google.com/o/oauth2/auth",
#   "token_uri": "https://oauth2.googleapis.com/token",
#   "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
#   "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-ukxfh%40carbonless-6e60d.iam.gserviceaccount.com"
# }
# ')),
      "Carbonless"
    )
  end

  def call
    message = {
      'topic': "89023", # OR token if you want to send to a specific device
      # 'token': "000iddqd",
      'data': {
        payload: {
          data: {
            id: 1
          }
        }.to_json
      },
      'notification': {
        title: 'Test',
        body: 'GTGEG',
      },
      'android': {},
      'apns': {
        payload: {
          aps: {
            sound: "default",
            category: "#{Time.zone.now.to_i}"
          }
        }
      },
    }

    @fcm.send_v1(message)
  end

  def test
    @fcm.send_to_topic("yourTopic", notification: {body: "This is a FCM Topic Message!"})
  end
end