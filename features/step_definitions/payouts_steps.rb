Then /^мне должен отправиться сформированный файл$/ do
  xml =<<XML
<?xml version="1.0"?>
<payments xmlns="http://tempuri.org/ds.xsd">
  <payment>
    <destination>Z222222222222</destination>
    <amount>30.0</amount>
    <description>MP3CMPS (webmoney) : masspay.</description>
    <id>1</id>
  </payment>
</payments>
XML
  page.body.should == xml
end
