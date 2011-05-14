package com.oneup.rpcoder.test {
    import org.flexunit.asserts.assertEquals;
    import com.oneup.rpcoder.generated.*;

    public class TypeTest
    {
        [Test(description="オブジェクトを作成できる")]
        public function createObject():void
        {
            var data:Object = {subject:'hi', body: 'foo bar'};
            var mail:Mail = new Mail(data);
            assertEquals(data['subject'], mail.subject);
            assertEquals(data['body'], mail.body);
        }

        [Test(description="少ないデータをもとにオブジェクトを作成できる")]
        public function createObjectWithFewData():void
        {
            var data:Object = {subject:'hi'};
            var mail:Mail = new Mail(data);
            assertEquals(data['subject'], mail.subject);
            assertEquals(null, mail.body);
        }
    }
}
