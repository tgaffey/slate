<?php

namespace Slate\UI;

class User implements IOmnibarSource
{
	public static function getOmnibarItems()
	{
		if ($User = $_SESSION['User']) {
			return [
				$User->FullName => [
					'_shortLabel' => $User->FirstName,
					'_href' => $User->getUrl(),
					'_iconSrc' => $User->PrimaryPhoto ? $User->PrimaryPhoto->getThumbnailRequest(Omnibar::$preferredIconSize) : null,
					'My Profile' => [
						'_icon' => 'user',
						'_href' => $User->getUrl()
					],
					'Edit Profile' => [
						'_icon' => 'gearhead',
						'_href' => '/profile'
					],
					'My Drafts' => [
						'_icon' => 'writing',
						'_href' => '/drafts'
					],
//					// TODO: this menu is exaggurated to test deep nesting, the simpler menu above is what should be shipped
					'My Content' => [
						'_icon' => 'writing',
						'Blogging' => [
							'_href' => '/blog',
							'Create Post' => '/blog/create',
							'My Drafts' => '/drafts'
						],
						'Pages' => $User->hasAccountLevel('Staff') ? '/pages' : null
					],
					'Log Out' => [
						'_icon' => 'logout',
						'_href' => '/logout?return=' . urlencode($_SERVER['REQUEST_URI'])
					]
				]
			];
		} else {
			return [
				'Log In' => '/login?return=' . urlencode($_SERVER['REQUEST_URI'])
			];
		}
	}
}