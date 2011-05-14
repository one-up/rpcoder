package com.oneup.rpcoder.test {
    import mx.rpc.AsyncToken;
    import mx.rpc.http.HTTPService;
    import flash.events.*;
    import mockolate.*;
    import mx.rpc.events.FaultEvent;
    import org.flexunit.asserts.*;
    import org.flexunit.async.Async;
    import org.hamcrest.core.anything;

    import com.oneup.rpcoder.generated.*;

    public class APITest {
        /*
         * Preparing
         */
        [Before(async, timeout=5000)]
        public function prepareMockolates() : void {
            Async.proceedOnEvent(this, prepare(API, HTTPService, AsyncToken), Event.COMPLETE);
        }

        [Test(description="API を new できる")]
        public function newAPI() : void {
            var api : API = new API('http://example.com/');
            assertEquals('http://example.com/', api.baseUrl);
        }

        [Test(description="API#getMail を呼び出せる")]
        public function callGetMail() : void {
            var api : API = nice(API);
            mock(api).method("request").args('GET', '/mails/1', anything(), anything(), anything());
            stub(api).method("getMail").callsSuper();
            api.getMail(
                1,
                function(mail : Mail) : void {},
                function(e : FaultEvent) : void {}
            );
            verify(api);
        }

        [Test(description="API#sendMail を呼び出せる")]
        public function callSendMail() : void {
            var api : API = nice(API);
            mock(api).method("request").args('POST', '/mails', anything(), anything(), anything());
            stub(api).method("sendMail").callsSuper();
            api.sendMail(
                'hi',
                'foo bar',
                function(mail : Mail) : void {},
                function(e : FaultEvent) : void {}
            );
            verify(api);
        }

        [Test(description="API#request を呼び出せる")]
        public function callRequest() : void {
            var api : API = nice(API);
            var service : HTTPService = strict(HTTPService);
            var token : AsyncToken = strict(AsyncToken);
            var params : Object = {foo:'foo', bar:'bar'};

            stub(api).method("createHttpService").anyArgs().returns(service);
            mock(service).setter("method").arg("GET");
            mock(service).setter("url").arg('/foo');
            mock(service).setter("request").arg(params);
            mock(service).setter("resultFormat").arg("text");
            mock(service).method("send").returns(token);
            mock(token).method("addResponder").anyArgs();

            stub(api).method("request").callsSuper();
            api.request('GET', '/foo', params, function():void{}, function():void{});

            verify(service);
        }
    }
}
