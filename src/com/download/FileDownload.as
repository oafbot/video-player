package com.download {
    import flash.events.*;
    import flash.net.FileReference;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    
    import mx.controls.Button;
    import mx.controls.ProgressBar;
    import mx.core.UIComponent;

    public class FileDownload extends UIComponent {

        public var DOWNLOAD_URL:String;
        private var fr:FileReference;
        // Define reference to the download ProgressBar component.
        private var pb:ProgressBar;
        // Define reference to the "Cancel" button which will immediately stop the download in progress.
        private var btn:Button;
		private var fileName:String;
		private var loader:URLLoader;
		private var request:URLRequest;
		
        public function FileDownload() {

        }

        /**
         * Set references to the components, and add listeners for the OPEN,
         * PROGRESS, and COMPLETE events.
         */
        public function init(pb:ProgressBar, btn:Button, dURL:String, fileName:String ):void {
            // Set up the references to the progress bar and cancel button, which are passed from the calling script.
            this.pb = pb;
            this.btn = btn;
			this.fileName = fileName;
			
            DOWNLOAD_URL = dURL;

            fr = new FileReference();
            fr.addEventListener(Event.OPEN, openHandler);
            fr.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            fr.addEventListener(Event.COMPLETE, completeHandler);
        }

        /**
         * Immediately cancel the download in progress and disable the cancel button.
         */
        public function cancelDownload():void {
            fr.cancel();
            pb.label = "DOWNLOAD CANCELLED";
            btn.enabled = false;
            deleteTemp();
        }

        /**
         * Begin downloading the file specified in the DOWNLOAD_URL constant.
         */
        public function startDownload():void {
            var request:URLRequest = new URLRequest();
            request.url = DOWNLOAD_URL;
            fr.download(request);
        }

        /**
         * When the OPEN event has dispatched, change the progress bar's label
         * and enable the "Cancel" button, which allows the user to abort the
         * download operation.
         */
        private function openHandler(event:Event):void {
            pb.label = "DOWNLOADING %3%%";
            //btn.enabled = true;
            btn.enabled = false;
            pb.visible = true;
        }

        /**
         * While the file is downloading, update the progress bar's status and label.
         */
        private function progressHandler(event:ProgressEvent):void {
            pb.setProgress(event.bytesLoaded, event.bytesTotal);
        }

        /**
         * Once the download has completed, change the progress bar's label and
         * disable the "Cancel" button since the download is already completed.
         */
        private function completeHandler(event:Event):void {
            //pb.label = "DOWNLOAD COMPLETE";
            pb.setProgress(0, 100);
            //btn.enabled = false;
            btn.enabled = true;
            pb.visible = false;
            deleteTemp();
        }
        private function deleteTemp():void{
        	request = new URLRequest("http://platypo.us/video/unlinkTemp.php?delete="+fileName);
			request.method = URLRequestMethod.GET;
			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, requestComplete);
			//loader.addEventListener("httpStatus", onHTTPStatus);
			//loader.addEventListener("complete", requestComplete);
			loader.load(request);
        }
    	private function requestComplete(evt:Event):void {

			if (evt.target.data == "deleted"){
				loader.close();
			}			
			else{
				loader.close();
			}
  			
		}       

    }	//class
}	//package
