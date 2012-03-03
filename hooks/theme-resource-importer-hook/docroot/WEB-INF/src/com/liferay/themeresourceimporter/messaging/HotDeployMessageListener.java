/**
 * Copyright (c) 2000-2012 Liferay, Inc. All rights reserved.
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

package com.liferay.themeresourceimporter.messaging;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.messaging.BaseMessageListener;
import com.liferay.portal.kernel.messaging.Message;
import com.liferay.portal.kernel.servlet.ServletContextPool;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.TextFormatter;
import com.liferay.portal.model.Company;
import com.liferay.portal.model.LayoutSetPrototype;
import com.liferay.portal.service.CompanyLocalServiceUtil;
import com.liferay.portal.service.GroupLocalServiceUtil;
import com.liferay.portal.util.PortalUtil;
import com.liferay.themeresourceimporter.importer.LarImporter;

import java.io.File;

import java.util.List;

import javax.servlet.ServletContext;

/**
 * @author Ryan Park
 */
public class HotDeployMessageListener extends BaseMessageListener {

	@Override
	protected void doReceive(Message message) throws Exception {
		String command = message.getString("command");
		String servletContextName = message.getString("servletContextName");

		if (!command.equals("deploy") ||
			!servletContextName.endsWith("-theme")) {

			return;
		}

		ServletContext servletContext = ServletContextPool.get(
			servletContextName);

		File resourceDir = new File(
			servletContext.getRealPath("/WEB-INF/classes/resources"));

		if (!resourceDir.exists()) {
			return;
		}

		_log.info("Importing resources from " + servletContextName);

		String name = TextFormatter.format(servletContextName, TextFormatter.J);

		File lar = new File(resourceDir, "/archive.lar");

		if (!lar.exists()) {
			return;
		}

		List<Company> companies = CompanyLocalServiceUtil.getCompanies();

		for (Company company : companies) {
			if (hasLayoutSetPrototype(company.getCompanyId(), name)) {
				continue;
			}

			LarImporter.importResource(company.getCompanyId(), name, lar);
		}
	}

	protected boolean hasLayoutSetPrototype(long companyId, String name)
		throws Exception {

		long layoutSetPrototypeClassNameId = PortalUtil.getClassNameId(
			LayoutSetPrototype.class.getName());

		int count = GroupLocalServiceUtil.searchCount(
			companyId, new long[] {layoutSetPrototypeClassNameId}, name,
			StringPool.BLANK, null);

		if (count > 0) {
			return true;
		}
		else {
			return false;
		}
	}

	private static Log _log = LogFactoryUtil.getLog(
		HotDeployMessageListener.class);

}