/*
 *  Copyright 2015 Adobe Systems Incorporated
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
package com.adobe.aem.guides.wknd.it.tests;

import com.adobe.cq.testing.client.CQClient;
import com.adobe.cq.testing.junit.rules.CQPublishClassRule;
import com.adobe.cq.testing.junit.rules.CQRule;
import org.apache.sling.testing.clients.ClientException;
import org.apache.sling.testing.clients.SlingHttpResponse;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.select.Elements;
import org.junit.*;

import static org.junit.Assert.assertEquals;


public class SamplePublishIT {
    @ClassRule
    public static final CQPublishClassRule cqBaseClassRule = new CQPublishClassRule();

    @Rule
    public CQRule cqBaseRule = new CQRule(cqBaseClassRule.publishRule);

    static CQClient adminPublish;

    @BeforeClass
    public static void beforeClass() throws ClientException {
        adminPublish = cqBaseClassRule.publishRule.getAdminClient(CQClient.class);
    }

    /**
     * This POC test verifies that the homepage contains the expected title.
     * In a real world scenario we should NOT write tests that rely on content that is handled by content authors
     * @throws ClientException if cannot connect
     */
    @Test
    public void testPublishPage() throws ClientException {
        SlingHttpResponse response = adminPublish.doGet("/", 200);

        // get html rendered component
        Document document = Jsoup.parse(response.getContent());

        // content is rendered as: <h2 class="cmp-byline__name">Andres</h2>
        Elements name = document.select("title");
        assertEquals("WKND Adventures and Travel",name.text());
    }
}
