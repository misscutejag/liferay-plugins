<%--
/**
 * Copyright (c) 2000-2013 Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
--%>

<%@ include file="/section/init.jsp" %>

<%
String tabs2 = ParamUtil.getString(request, "tabs2", "general");
%>

<liferay-portlet:renderURL portletConfiguration="true" var="portletURL">
	<portlet:param name="tabs2" value="<%= tabs2 %>" />
</liferay-portlet:renderURL>

<liferay-ui:tabs
	names="general,display-settings,rss"
	param="tabs2"
	url="<%= portletURL %>"
/>

<liferay-portlet:actionURL portletConfiguration="true" var="configurationURL" />

<aui:form action="<%= configurationURL %>" method="post" name="fm">
	<aui:input name="<%= Constants.CMD %>" type="hidden" value="<%= Constants.UPDATE %>" />
	<aui:input name="tabs2" type="hidden" value="<%= tabs2 %>" />

	<liferay-ui:error key="kbArticlesSections" message="please-select-at-least-one-section" />

	<aui:fieldset>
		<c:choose>
			<c:when test='<%= tabs2.equals("general") %>'>
				<aui:input label="show-sections-title" name="preferences--showKBArticlesSectionsTitle--" type="checkbox" value="<%= showKBArticlesSectionsTitle %>" />

				<aui:select cssClass="kb-field-wrapper" ignoreRequestValue="<%= true %>" label="sections" multiple="<%= true %>" name="kbArticlesSections">

					<%
					Map<String, String> sectionsMap = new TreeMap<String, String>();

					for (String section : PortletPropsValues.ADMIN_KB_ARTICLE_SECTIONS) {
						sectionsMap.put(LanguageUtil.get(pageContext, section), section);
					}

					for (Map.Entry<String, String> entry : sectionsMap.entrySet()) {
					%>

						<aui:option label="<%= entry.getKey() %>" selected="<%= ArrayUtil.contains(kbArticlesSections, entry.getValue()) %>" value="<%= entry.getValue() %>" />

					<%
					}
					%>

				</aui:select>

				<aui:select label="article-display-style" name="preferences--kbArticleDisplayStyle--">
					<aui:option label="title" selected='<%= kbArticleDisplayStyle.equals("title") %>' />
					<aui:option label="abstract" selected='<%= kbArticleDisplayStyle.equals("abstract") %>' />
				</aui:select>

				<aui:select label="article-window-state" name="preferences--kbArticleWindowState--">
					<aui:option label="maximized" selected="<%= kbArticleWindowState.equals(WindowState.MAXIMIZED.toString()) %>" value="<%= WindowState.MAXIMIZED.toString() %>" />
					<aui:option label="normal" selected="<%= kbArticleWindowState.equals(WindowState.NORMAL.toString()) %>" value="<%= WindowState.NORMAL.toString() %>" />
				</aui:select>

				<div class="kb-block-labels kb-field-wrapper">
					<aui:select inlineField="<%= true %>" label="order-by" name="preferences--kbArticlesOrderByCol--">
						<aui:option label="create-date" selected='<%= kbArticlesOrderByCol.equals("create-date") %>' />
						<aui:option label="modified-date" selected='<%= kbArticlesOrderByCol.equals("modified-date") %>' />
						<aui:option label="priority" selected='<%= kbArticlesOrderByCol.equals("priority") %>' />
						<aui:option label="title" selected='<%= kbArticlesOrderByCol.equals("title") %>' />
						<aui:option label="view-count" selected='<%= kbArticlesOrderByCol.equals("view-count") %>' />
					</aui:select>

					<aui:select inlineField="<%= true %>" label="<%= StringPool.NBSP %>" name="preferences--kbArticlesOrderByType--">
						<aui:option label="ascending" selected='<%= kbArticlesOrderByType.equals("asc") %>' value="asc" />
						<aui:option label="descending" selected='<%= kbArticlesOrderByType.equals("desc") %>' value="desc" />
					</aui:select>
				</div>

				<aui:select cssClass="kb-field-wrapper" label="items-per-page" name="preferences--kbArticlesDelta--">

					<%
					int[] pageDeltaValues = GetterUtil.getIntegerValues(PropsUtil.getArray(PropsKeys.SEARCH_CONTAINER_PAGE_DELTA_VALUES));

					Arrays.sort(pageDeltaValues);

					for (int pageDeltaValue : pageDeltaValues) {
					%>

						<aui:option label="<%= pageDeltaValue %>" selected="<%= kbArticlesDelta == pageDeltaValue %>" />

					<%
					}
					%>

				</aui:select>

				<aui:input label="show-pagination" name="preferences--showKBArticlesPagination--" type="checkbox" value="<%= showKBArticlesPagination %>" />
			</c:when>
			<c:when test='<%= tabs2.equals("display-settings") %>'>
				<aui:input label="enable-description" name="preferences--enableKBArticleDescription--" type="checkbox" value="<%= enableKBArticleDescription %>" />

				<aui:input label="enable-ratings" name="preferences--enableKBArticleRatings--" type="checkbox" value="<%= enableKBArticleRatings %>" />

				<aui:input label="show-asset-entries" name="preferences--showKBArticleAssetEntries--" type="checkbox" value="<%= showKBArticleAssetEntries %>" />

				<aui:input label="enable-comments" name="preferences--enableKBArticleKBComments--" type="checkbox" value="<%= enableKBArticleKBComments %>" />

				<aui:input label="show-comments" name="preferences--showKBArticleKBComments--" type="checkbox" value="<%= showKBArticleKBComments %>" />

				<aui:input label="enable-view-count-increment" name="preferences--enableKBArticleViewCountIncrement--" type="checkbox" value="<%= enableKBArticleViewCountIncrement %>" />
			</c:when>
			<c:when test='<%= tabs2.equals("rss") %>'>
				<aui:select label="maximum-items-to-display" name="preferences--rssDelta--">
					<aui:option label="1" selected="<%= rssDelta == 1 %>" />
					<aui:option label="2" selected="<%= rssDelta == 2 %>" />
					<aui:option label="3" selected="<%= rssDelta == 3 %>" />
					<aui:option label="4" selected="<%= rssDelta == 4 %>" />
					<aui:option label="5" selected="<%= rssDelta == 5 %>" />
					<aui:option label="10" selected="<%= rssDelta == 10 %>" />
					<aui:option label="15" selected="<%= rssDelta == 15 %>" />
					<aui:option label="20" selected="<%= rssDelta == 20 %>" />
					<aui:option label="25" selected="<%= rssDelta == 25 %>" />
					<aui:option label="30" selected="<%= rssDelta == 30 %>" />
					<aui:option label="40" selected="<%= rssDelta == 40 %>" />
					<aui:option label="50" selected="<%= rssDelta == 50 %>" />
					<aui:option label="60" selected="<%= rssDelta == 60 %>" />
					<aui:option label="70" selected="<%= rssDelta == 70 %>" />
					<aui:option label="80" selected="<%= rssDelta == 80 %>" />
					<aui:option label="90" selected="<%= rssDelta == 90 %>" />
					<aui:option label="100" selected="<%= rssDelta == 100 %>" />
				</aui:select>

				<aui:select label="display-style" name="preferences--rssDisplayStyle--">
					<aui:option label="<%= RSSUtil.DISPLAY_STYLE_FULL_CONTENT %>" selected="<%= rssDisplayStyle.equals(RSSUtil.DISPLAY_STYLE_FULL_CONTENT) %>" />
					<aui:option label="<%= RSSUtil.DISPLAY_STYLE_ABSTRACT %>" selected="<%= rssDisplayStyle.equals(RSSUtil.DISPLAY_STYLE_ABSTRACT) %>" />
					<aui:option label="<%= RSSUtil.DISPLAY_STYLE_TITLE %>" selected="<%= rssDisplayStyle.equals(RSSUtil.DISPLAY_STYLE_TITLE) %>" />
				</aui:select>

				<aui:select label="format" name="preferences--rssFormat--">
					<aui:option label="RSS 1.0" selected='<%= rssFormat.equals("rss10") %>' value="rss10" />
					<aui:option label="RSS 2.0" selected='<%= rssFormat.equals("rss20") %>' value="rss20" />
					<aui:option label="Atom 1.0" selected='<%= rssFormat.equals("atom10") %>' value="atom10" />
				</aui:select>
			</c:when>
		</c:choose>

		<aui:button-row cssClass="kb-submit-buttons">
			<aui:button type="submit" />
		</aui:button-row>
	</aui:fieldset>
</aui:form>